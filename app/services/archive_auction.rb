class ArchiveAuction
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    if auction.unpublished?
      auction.published = :archived
      auction.save
    else
      false
    end
  end

  def self.archive_submit?(params)
    params.key?(:archive_auction)
  end
end
