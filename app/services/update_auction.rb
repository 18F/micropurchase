class UpdateAuction
  def initialize(auction:, params:, current_user:)
    @auction = auction
    @params = params
    @current_user = current_user
  end

  def perform
    assign_attributes
    update_auction_ended_job

    if vendor_ineligible?
      auction.errors.add(:base, 'The vendor cannot be paid')
      false
    else
      perform_approved_auction_tasks
      perform_rejected_auction_tasks
      auction.save
    end
  end

  private

  attr_reader :auction, :params, :current_user

  def assign_attributes
    auction.assign_attributes(attributes)
  end

  def update_auction_ended_job
    if updating_ended_at?
      if find_auction_ended_job
        find_auction_ended_job.update(run_at: auction.ended_at)
      else
        create_auction_ended_job
      end
    end
  end

  def find_auction_ended_job
    @_find_auction_ended_job ||=
      Delayed::Job
      .where(queue: 'auction_ended')
      .where(auction_id: auction.id)
      .first
  end

  def create_auction_ended_job
    CreateAuctionEndedJob.new(auction).perform
  end

  def updating_ended_at?
    attributes.key?(:ended_at)
  end

  def perform_approved_auction_tasks
    if auction.accepted? && auction.accepted_at.nil? && auction.bids.any?
      AcceptAuction.new(
        auction: auction,
        payment_url: winning_bidder.payment_url
      ).perform
    end
  end

  def perform_rejected_auction_tasks
    if auction_rejected? && auction.rejected_at.nil?
      auction.rejected_at = Time.current
    end
  end

  def vendor_ineligible?
    auction_accepted? && !winning_bidder_is_eligible_to_be_paid?
  end

  def auction_accepted?
    attributes[:result] == 'accepted'
  end

  def auction_rejected?
    attributes[:result] == 'rejected'
  end

  def winning_bidder_is_eligible_to_be_paid?
    if auction_is_small_business?
      reckoner = SamAccountReckoner.new(winning_bidder)
      reckoner.set!
      winning_bidder.reload

      user_is_eligible_to_bid?
    else
      true
    end
  end

  def user_is_eligible_to_bid?
    auction_rules.user_is_eligible_to_bid?(winning_bidder)
  end

  def auction_rules
    RulesFactory.new(auction).create
  end

  def auction_is_small_business?
    AuctionThreshold.new(auction).small_business?
  end

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def attributes
    @_attributes ||= AuctionParser.new(params, user).attributes
  end

  def user
    auction.user || current_user
  end
end
