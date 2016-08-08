class AuctionQuery
  attr_reader :relation

  def initialize(relation = Auction.all)
    @relation = relation
  end

  def public_index
    relation.published.with_bids.in_reverse_chron_order
  end

  def public_find(id)
    relation.published.find(id)
  end

  def active_auction_count
    public_index
      .started_at_in_past
      .ended_at_in_future
      .count
  end

  def upcoming_auction_count
    public_index.started_at_in_future.count
  end

  def complete_and_successful
    relation
      .delivery_due_at_expired
      .delivered
      .delivery_accepted
      .paid
  end

  def completed
    relation
      .published
      .delivery_due_at_expired
      .with_bids_and_bidders
      .where.not(bids: { id: nil })
  end

  def rejected
    relation.rejected
  end

  def payment_needed
    relation
      .delivery_due_at_expired
      .delivered
      .delivery_accepted
      .c2_submitted
      .not_paid
  end

  def pending_acceptance
    relation.pending_acceptance
  end

  def delivery_past_due
    relation.delivery_due_at_expired.not_delivered
  end

  def bids_index(id)
    relation
      .with_bids_and_bidders
      .published
      .find(id)
  end

  def with_bid_from_user(user_id)
    relation
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end

  def accepted_with_bid_from_user(user_id)
    relation
      .accepted
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end
end
