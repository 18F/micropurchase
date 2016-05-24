class BidSerializer < ActiveModel::Serializer
  has_one :bidder, class_name: 'User', serializer: UserSerializer

  attributes(
    :amount,
    :auction_id,
    :bidder_id,
    :created_at,
    :id,
    :updated_at
  )

  def bidder_id
    veiled_bidder_id
  end

  def bidder
    veiled_bidder
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.created_at.iso8601
  end

  private

  def veiled_bidder_id
    if auction_available? && object.bidder != scope
      nil
    else
      bidder.id
    end
  end

  def veiled_bidder
    if auction_available? && object.bidder != scope
      VeiledBidderPresenter.new
    else
      object.bidder
    end
  end

  def auction_available?
    AuctionStatus.new(object.auction).available?
  end
end
