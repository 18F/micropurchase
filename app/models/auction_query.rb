class AuctionQuery
  def initialize(relation = Auction.all)
    @relation = relation.extending(Scopes)
  end

  [
    :delivery_deadline_expired,
    :accepted,
    :not_evaluated,
    :delivered,
    :not_delivered,
    :cap_submitted,
    :cap_not_submitted,
    :paid,
    :not_paid,
    :in_reverse_chron_order,
    :with_bids,
    :with_bids_and_bidders,
    :published,
    :unpublished
  ].each do |key|
    define_method key do
      @relation.send(key)
    end
  end

  def complete_and_successful
    @relation
      .delivery_deadline_expired
      .delivered
      .accepted
      .cap_submitted
      .paid
  end

  def payment_pending
    @relation
      .delivery_deadline_expired
      .delivered
      .accepted
      .cap_submitted
      .not_paid
  end

  def payment_needed
    @relation
      .delivery_deadline_expired
      .delivered
      .accepted
      .cap_not_submitted
      .not_paid
  end

  def evaluation_needed
    @relation
      .delivery_deadline_expired
      .delivered
      .not_evaluated
  end

  def delivery_past_due
    @relation
      .delivery_deadline_expired
      .not_delivered
  end

  def public_index
    @relation
      .published
      .with_bids
      .in_reverse_chron_order
  end

  def public_find(id)
    @relation
      .published
      .find(id)
  end

  def my_bids(user_id)
    @relation
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end

  module Scopes
    def delivery_deadline_expired
      where('delivery_deadline < ?', Time.zone.now)
    end

    def accepted
      where(result: accepted_enum)
    end

    def not_evaluated
      where(result: [nil, not_applicable_enum])
    end

    def delivered
      where.not(delivery_url: [nil, ""])
    end

    def not_delivered
      where(delivery_url: [nil, ""])
    end

    def cap_submitted
      where.not(cap_proposal_url: [nil, ""])
    end

    def cap_not_submitted
      where(cap_proposal_url: [nil, ""])
    end

    def paid
      where(
        awardee_paid_status: paid_enum
      )
    end

    def not_paid
      where(
        awardee_paid_status: not_paid_enum
      )
    end

    def in_reverse_chron_order
      order('end_datetime DESC')
    end

    def with_bids
      includes(:bids)
    end

    def with_bids_and_bidders
      includes(:bids, :bidders)
    end

    def published
      where(published: published_enum)
    end

    def unpublished
      where(published: [nil, '', unpublished_enum])
    end

    private

    def paid_enum
      Auction.awardee_paid_statuses['paid']
    end

    def not_paid_enum
      Auction.awardee_paid_statuses['not_paid']
    end

    def accepted_enum
      Auction.results['accepted']
    end

    def not_applicable_enum
      Auction.results['not_applicable']
    end

    def published_enum
      Auction.publisheds['published']
    end

    def unpublished_enum
      Auction.publisheds['unpublished']
    end
  end
end
