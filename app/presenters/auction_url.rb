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
    if Rails.env.development? || Rails.env.test?
      ENV['ROOT_URL']
    else
      VCAPApplication.application_uris.first
    end
  end
end
