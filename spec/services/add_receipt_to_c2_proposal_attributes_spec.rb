require 'rails_helper'

describe AddReceiptToC2ProposalAttributes do
  describe '#perform' do
    it 'should return a hash with the link to product' do
      auction = create(:auction)
      url = ReceiptUrl.new(auction).to_s

      attributes = AddReceiptToC2ProposalAttributes.new(auction).perform

      expect(attributes[:gsa18f_procurement][:link_to_product]).to eq(url)
    end
  end
end
