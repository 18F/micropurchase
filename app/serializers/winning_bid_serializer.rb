class WinningBidSerializer < ActiveModel::Serializer
  root false

  attributes(
    :amount,
    :bidder_id
  )

  def amount
    object.amount
  end

  def bidder_id
    object.bidder_id
  end
end
