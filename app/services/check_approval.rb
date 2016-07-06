class CheckApproval < C2ApiWrapper
  def initialize(auctions = AuctionQuery.new.unpublished)
    @auctions = auctions
  end

  def perform
    auctions.each do |auction|
      next if auction.cap_proposal_url.blank?
      approved_at = find_approval_timestamp(proposal_json(auction))

      if approved_at
        auction.update(c2_approved_at: DateTime.parse(approved_at))
      end
    end
  end

  private

  attr_reader :auctions

  def find_approval_timestamp(proposal_json)
    parsed_json = proposal_json.body
    purchase_step = parsed_json[:steps].detect do |step|
      step[:type] == "Steps::Approval"
    end

    purchase_step[:completed_at]
  end
end
