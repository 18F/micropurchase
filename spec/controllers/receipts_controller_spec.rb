require 'rails_helper'

describe ReceiptsController do
  describe '#new' do
    context 'current user is winning vendor' do
      context 'auction is paid' do
        it 'does not redirect the user' do
          auction = create(:auction, :with_bidders, :paid)
          current_user = create(:user)
          bid = auction.bids.sort_by(&:amount).first
          bid.update(bidder: current_user)

          get :new, { auction_id: auction.id }, user_id: current_user.id

          expect(response.code).to eq '200'
          expect(response).to render_template(:new)
        end
      end

      context 'auction is not paid' do
        it 'redirects the user' do
          auction = create(:auction, :with_bidders, :available)
          current_user = create(:user)
          bid = auction.bids.sort_by(&:amount).first
          bid.update(bidder: current_user)

          get :new, { auction_id: auction.id }, user_id: current_user.id

          expect(response).to be_redirect
          expect(response.location).to eq('http://test.host/')
        end
      end
    end

    context 'current user is not winning vendor' do
      it 'redirects the user' do
        auction = create(:auction, :paid)
        current_user = create(:user)

        get :new, { auction_id: auction.id }, user_id: current_user.id

        expect(response).to be_redirect
        expect(response.location).to eq('http://test.host/')
      end
    end

    context 'current user is a guest' do
      it 'redirects the user' do
        auction = create(:auction, :paid)

        get :new, { auction_id: auction.id }, user_id: nil

        expect(response).to be_redirect
        expect(response.location).to eq('http://test.host/sign_in')
      end
    end
  end
end
