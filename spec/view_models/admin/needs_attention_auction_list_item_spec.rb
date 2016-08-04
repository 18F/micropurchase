require 'rails_helper'

describe Admin::NeedsAttentionAuctionListItem do
  describe '#c2_proposal_url' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal URL' do
        auction = create(:auction, purchase_card: :default)

        view_model = Admin::NeedsAttentionAuctionListItem.new(auction)

        expect(view_model.c2_proposal_url).to eq auction.c2_proposal_url
      end
    end

    context 'auction for other purchase card' do
      it 'returns n/a' do
        auction = create(:auction, purchase_card: :other)

        view_model = Admin::NeedsAttentionAuctionListItem.new(auction)

        expect(view_model.c2_proposal_url).to eq 'N/A'
      end
    end
  end
end
