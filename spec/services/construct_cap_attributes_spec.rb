require 'rails_helper'

describe ConstructCapAttributes do
  describe '#perform' do
    it 'constructs the correct attributes' do
      auction = FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
      auction_presenter = AuctionPresenter.new(auction)

      attributes = ConstructCapAttributes.new(auction_presenter).perform
      gsa_attributes = attributes[:gsa18f_procurement]

      expect(gsa_attributes[:product_name_and_description]).to include(auction_presenter.title)
      expect(gsa_attributes[:product_name_and_description]).to include(auction_presenter.url)
      expect(gsa_attributes[:product_name_and_description]).to include(auction_presenter.summary)

      expect(gsa_attributes[:justification]).to include(auction_presenter.billable_to)

      expect(gsa_attributes[:link_to_product]).to eq(auction_presenter.delivery_url)

      expect(gsa_attributes[:cost_per_unit]).to eq(auction_presenter.winning_bid.amount)

      expect(gsa_attributes[:date_requested]).to eq(Date.current.iso8601)

      winning_bidder = auction_presenter.winning_bid.bidder
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.name)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.email)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.duns_number)
      expect(gsa_attributes[:additional_info]).to include(winning_bidder.credit_card_form_url)
    end
  end
end
