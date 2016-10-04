class ArchiveAuction
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    if auction.unpublished?
      auction.published = :archived
      update_c2_status
      auction.save
    else
      false
    end
  end

  def self.archive_submit?(params)
    params.key?(:archive_auction)
  end

  private

  def update_c2_status
    if auction.c2_proposal_url.present?
      UpdateC2ProposalJob.perform_later(auction.id, 'C2CancelAttributes')
      auction.c2_status = :c2_canceled
    end
  end
end
