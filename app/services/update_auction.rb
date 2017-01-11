class UpdateAuction
  def initialize(auction:, params:, current_user:)
    @auction = auction
    @params = params
    @current_user = current_user
  end

  def perform
    assign_attributes
    create_auction_states
    update_auction_ended_job
    perform_accepted_auction_tasks
    perform_rejected_auction_tasks
    auction.save
  end

  private

  attr_reader :auction, :params, :current_user

  def create_auction_states
    create_published_state
    # add more state creation here, as needed
  end

  def create_published_state
    if parser.publishing?
      auction_state = AuctionState.new(auction_id: auction.id,
                                       name: 'published',
                                       state_value: 'published')
      auction_state.save
    end
  end

  def assign_attributes
    auction.assign_attributes(parsed_attributes)
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
    parsed_attributes.key?(:ended_at)
  end

  def perform_accepted_auction_tasks
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
      WinningBidderMailer.auction_rejected(auction: auction).deliver_later
    end
  end

  def auction_accepted?
    parsed_attributes[:status] == 'accepted'
  end

  def auction_rejected?
    parsed_attributes[:status] == 'rejected'
  end

  def parser
    @_parser ||= AuctionParser.new(params, user)
  end

  def parsed_attributes
    parser.attributes
  end

  def user
    auction.user || current_user
  end
end
