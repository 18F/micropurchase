class UpdateAuctionsBillableData
  def perform
    auction_tock_mappings.each do |mapping|
      auctions = Auction.where(billable_to: mapping[:auction_billable_to])
      account = ClientAccount.find_by(tock_id: mapping[:tock_id])
      auctions.each { |auction| auction.update(billable_to: account.to_s) }
    end
  end

  private

  def auction_tock_mappings
    [
      { auction_billable_to: "Micropurchase", tock_id: 237 },
      { auction_billable_to: "Open Opportunities", tock_id: 206 },
      { auction_billable_to: "Tock", tock_id: 62 },
      { auction_billable_to: "GP - API Program", tock_id: 92 },
      { auction_billable_to: "Playbook in Action", tock_id: 83 }
    ]
  end
end
