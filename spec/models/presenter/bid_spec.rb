require 'rails_helper'

RSpec.describe Presenter::Bid, type: :model do
  describe '==' do
    let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }
      
    it 'should be true if both wrap the same bid object' do
      ar_bid = ar_auction.bids.first
      
      expect(Presenter::Bid.new(ar_bid)).to eq(Presenter::Bid.new(ar_bid))
    end
  end
end
