class ReceiptUrl
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def to_s
    "#{root_url}/auctions/#{auction.id}/receipt"
  end

  private

  def root_url
    ENV['ROOT_URL']
  end
end
