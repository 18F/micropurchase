class UpdateAuction < Struct.new(:auction, :params, :user)
  def perform
    auction.assign_attributes(attributes)

    if should_create_cap_proposal?
      CreateCapProposalJob.perform_later(auction.id)
    end

    auction.save
  end

  def should_create_cap_proposal?
    attributes[:result] == 'accepted' && auction.cap_proposal_url.blank?
  end

  private

  def parser
    @_parser ||= AuctionParser.new(params, user)
  end

  delegate :attributes, to: :parser
end
