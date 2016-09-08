require 'rails_helper'

describe AuctionShowViewModel do
  describe '#nofollow_partial' do
    context 'when the auction is published' do
      it 'returns the null partial' do
        auction = create(:auction, :published)
        user = create(:user)

        view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

        expect(view_model.nofollow_partial).to eq('components/null')
      end
    end

    context 'when the auction is unpublished' do
      it 'returns the nofollow partial' do
        auction = create(:auction, :unpublished)
        user = create(:user)

        view_model = AuctionShowViewModel.new(auction: auction, current_user: user)

        expect(view_model.nofollow_partial).to eq('components/nofollow')
      end
    end
  end
end
