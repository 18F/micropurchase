require 'rails_helper'

describe ConstructCapAttributes do
  describe '#perform' do
    it 'constructs the correct attributes' do
      auction = create(:auction)
      url = AuctionUrl.new(auction).find

      attributes = ConstructCapAttributes.new(auction).perform
      gsa_attributes = attributes[:gsa18f_procurement]

      expect(gsa_attributes[:product_name_and_description]).to include(auction.title)
      expect(gsa_attributes[:product_name_and_description]).to include(url)
      expect(gsa_attributes[:product_name_and_description]).to include(auction.summary)
      expect(gsa_attributes[:justification]).to include(auction.billable_to)
      expect(gsa_attributes[:cost_per_unit]).to eq(auction.start_price)
      expect(gsa_attributes[:date_requested]).to eq(Date.current.iso8601)
    end
  end
end
