require 'rails_helper'

describe BuildAuction do
  describe '#perform' do
    context 'building with all valid params' do
      it 'builds the auction object' do
        user = create(:user)
        params = { auction: FactoryGirl.attributes_for(:auction) }

        auction = BuildAuction.new(params, user).perform

        expect(auction).to be_an(Auction)
      end
    end
  end
end
