class AuctionQuery
  def initialize(relation = Auction.all)
    @relation = relation.extending(Scopes)
  end

  [
    :delivery_due_at_expired,
    :accepted,
    :not_evaluated,
    :delivered,
    :not_delivered,
    :c2_submitted,
    :c2_not_submitted,
    :paid,
    :not_paid,
    :in_reverse_chron_order,
    :with_bids,
    :with_bids_and_bidders,
    :published,
    :unpublished,
    :closed_within_last_24_hours
  ].each do |key|
    define_method key do
      @relation.send(key)
    end
  end

  def active_auction_count
    public_index
      .started_at_in_past
      .ended_at_in_future
      .count
  end

  def upcoming_auction_count
    public_index
      .started_at_in_future
      .count
  end

  def complete_and_successful
    @relation
      .delivery_due_at_expired
      .delivered
      .accepted
      .c2_submitted
      .paid
  end

  def rejected
    @relation
      .rejected
  end

  def payment_pending
    @relation
      .delivery_due_at_expired
      .delivered
      .accepted
      .c2_submitted
      .not_paid
  end

  def payment_needed
    @relation
      .delivery_due_at_expired
      .delivered
      .accepted
      .c2_not_submitted
      .not_paid
  end

  def evaluation_needed
    @relation
      .delivery_due_at_expired
      .delivered
      .not_evaluated
  end

  def delivery_past_due
    @relation
      .delivery_due_at_expired
      .not_delivered
  end

  def public_index
    @relation
      .published
      .with_bids
      .in_reverse_chron_order
  end

  def bids_index(id)
    @relation
      .with_bids_and_bidders
      .published
      .find(id)
  end

  def public_find(id)
    @relation
      .published
      .find(id)
  end

  def with_bid_from_user(user_id)
    @relation
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end

  module Scopes
    def delivery_due_at_expired
      where('delivery_due_at < ?', Time.current)
    end

    def started_at_in_past
      where('started_at < ?', Time.current)
    end

    def started_at_in_future
      where('started_at > ?', Time.current)
    end

    def ended_at_in_future
      where('ended_at > ?', Time.current)
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

    def c2_submitted
      where.not(c2_proposal_url: [nil, ""])
    end

    def c2_not_submitted
      where(c2_proposal_url: [nil, ""])
    end

    def paid
      where.not(paid_at: nil)
    end

    def not_paid
      where(paid_at: nil)
    end

    def in_reverse_chron_order
      order('ended_at DESC')
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

    def closed_within_last_24_hours
      today = Time.current.to_date
      last_24_hours = today - 24.hours
      next_24_hours = today + 24.hours

      where(ended_at: last_24_hours..next_24_hours)
    end

    private

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
