require 'rails_helper'

describe Admin::DraftListItem do
  describe '#c2_proposal_url' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal URL' do
        auction = create(:auction, purchase_card: :default)

        view_model = Admin::DraftListItem.new(auction)

        expect(view_model.c2_proposal_status).to eq(
          AdminAuctionStatusPresenterFactory.new(auction: auction).create.status
        )
      end
    end

    context 'auction for other purchase card' do
      it 'returns n/a' do
        auction = create(:auction, purchase_card: :other)

        view_model = Admin::DraftListItem.new(auction)

        expect(view_model.c2_proposal_status).to eq 'N/A'
      end
    end
  end
end
