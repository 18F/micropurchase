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

  def upcoming_auction_count
    public_index.started_at_in_future.count
  end

  def active_auction_count
    public_index
      .started_at_in_past
      .ended_at_in_future
      .count
  end

  def needs_attention_count
    unpublished.count +
      pending_delivery.count +
      pending_acceptance.count +
      payment_needed.count
  end

  def unpublished
    relation.unpublished
  end

  def pending_acceptance
    relation.pending_acceptance
  end

  def completed
    relation.accepted_or_rejected
  end

  def complete_and_successful
    relation
      .delivery_due_at_expired
      .delivered
      .delivery_accepted
      .paid
  end

  def rejected
    relation.rejected
  end

  def pending_delivery
    relation.ended.pending_delivery
  end

  def c2_payment_needed
    relation
      .default_purchase_card
      .delivery_accepted
      .not_paid
  end

  def payment_needed
    relation
      .accepted
      .not_paid
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
