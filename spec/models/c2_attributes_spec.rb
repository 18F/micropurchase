require 'rails_helper'

describe C2Attributes do
  describe '#to_h' do
    it 'constructs the correct attributes' do
      auction = create(:auction)
      url = AuctionUrl.new(auction: auction).to_s

      attributes = C2Attributes.new(auction).to_h
      gsa_attributes = attributes[:gsa18f_procurement]

      expect(gsa_attributes[:cost_per_unit]).to eq(auction.start_price)
      expect(gsa_attributes[:date_requested]).to eq(Date.current.iso8601)
      expect(gsa_attributes[:justification]).to include(auction.billable_to)
      expect(gsa_attributes[:link_to_product]).to eq(url)
      expect(gsa_attributes[:product_name_and_description]).to include(auction.summary)
      expect(gsa_attributes[:product_name_and_description]).to include(auction.title)
    end
  end
end
