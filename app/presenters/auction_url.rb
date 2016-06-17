class AuctionUrl
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def find
    "#{root_url}/auctions/#{auction.id}"
  end

  private

  def root_url
    ENV['ROOT_URL']
  end
end
