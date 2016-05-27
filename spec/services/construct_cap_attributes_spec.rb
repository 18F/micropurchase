require 'rails_helper'

describe ConstructCapAttributes do
  describe '#perform' do
    it 'constructs the correct attributes' do
      auction = FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
      winning_bid = WinningBid.new(auction).find
      winning_bidder = winning_bid.bidder
      url = AuctionUrl.new(auction).find

      attributes = ConstructCapAttributes.new(auction).perform
      gsa_attributes = attributes[:gsa18f_procurement]

      expect(gsa_attributes[:product_name_and_description]).to include(auction.title)
      expect(gsa_attributes[:product_name_and_description]).to include(url)
      expect(gsa_attributes[:product_name_and_description]).to include(auction.summary)
      expect(gsa_attributes[:justification]).to include(auction.billable_to)
      expect(gsa_attributes[:link_to_product]).to eq(auction.delivery_url)
      expect(gsa_attributes[:cost_per_unit]).to eq(winning_bid.amount)
      expect(gsa_attributes[:date_requested]).to eq(Date.current.iso8601)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.name)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.email)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.duns_number)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.credit_card_form_url)
    end
  end
end
