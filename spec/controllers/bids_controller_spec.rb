require 'rails_helper'

RSpec.describe BidsController, controller: true do
  let(:current_bidder) { User.create(github_id: '12345')}
  let(:auction) { Auction.create(title: 'Refactor this disaster') }

  describe '#new' do
    before do
      allow(controller).to receive(:current_user).and_return(current_bidder)
    end

    it 'should render the bid information' do
      get :new, auction_id: auction.id
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when not logged in' do
      it 'redirects to authenticate' do
        get :create, auction_id: auction.id, amount: 1000.00
      end
    end

    context 'when there are no other bids' do
      it 'render success' do
        post :create, auction_id: auction.id, amount: 3000.00
        expect(response).to render_template(:create)
      end

      it "creats a bid for the current user and is the current bid"
    end

    context 'when the bid is lower than the current bid' do
    end

    context 'when the bid is higher than the current bid' do
    end

    context 'when the bid is the same as current bid' do
    end
  end
end

