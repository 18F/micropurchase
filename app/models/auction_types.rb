class AuctionTypes
  def to_a
    # reverse-alphabetize to ensure 'sealed-bid' is before 'reverse'
    Auction.types.keys.to_a.sort.reverse
  end
end
