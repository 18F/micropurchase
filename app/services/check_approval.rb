class CheckApproval < C2ApiWrapper
  def initialize(auctions = Auction.unpublished)
    @auctions = auctions
  end

  def perform
    auctions.each do |auction|
      next if auction.c2_proposal_url.blank? || auction.invalid?
      budget_approved_at = find_approval_timestamp(proposal_json(auction))

      if budget_approved_at
        auction.update(c2_status: :budget_approved)
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
