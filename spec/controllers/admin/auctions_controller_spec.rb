require 'rails_helper'

RSpec.describe Admin::AuctionsController, controller: true do
  let(:user) { FactoryGirl.create(:admin_user) }

  describe '#index' do
    it 'assigns presented auctions' do
      auction_record = FactoryGirl.create(:auction)
      get :index, { }, user_id: user.id
      auctions = assigns(:auctions)
      expect(auctions).to be_a(Array)
      auction = auctions.first
      expect(auction).to be_a(Presenter::AdminAuction)
      expect(auction.id).to eq(auction_record.id)
    end
  end

  describe '#show' do
    it 'assigns presented auction' do
      auction_record = FactoryGirl.create(:auction)
      get :show, { id: auction_record.id }, user_id: user.id
      auction = assigns(:auction)
      expect(auction).to be_a(Presenter::AdminAuction)
      expect(auction.id).to eq(auction_record.id)
    end
  end
end
