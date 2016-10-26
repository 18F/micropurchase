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

  def unpublished_find(token)
    relation.find_by(token: token)
  end

  def upcoming
    public_index.started_at_in_future.order('started_at ASC')
  end

  def upcoming_auction_count
    upcoming.count
  end

  def active_auction_count
    public_index
      .started_at_in_past
      .ended_at_in_future
      .count
  end

  def needs_attention_count
    relation.unpublished.count +
      delivery_needed.count +
      relation.pending_acceptance.count +
      payment_needed.count
  end

  def completed
    relation.evaluated
  end

  def complete_and_successful
    relation
      .delivery_url
      .accepted
      .paid
  end

  def rejected
    relation.rejected
  end

  def delivery_needed
    relation.published.ended.to_be_delivered
  end

  def c2_payment_needed
    relation
      .default_purchase_card
      .accepted
      .not_paid
  end

  def payment_needed
    relation
      .accepted_or_accepted_and_pending_payment_url
      .not_paid
  end

  def with_bid_from_user(user_id)
    relation
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end

  def accepted_pending_payment_url_with_bid_from_user(user_id)
    relation
      .accepted_pending_payment_url
      .joins(:bids)
      .where(bids: { bidder_id: user_id })
      .uniq
  end
end
