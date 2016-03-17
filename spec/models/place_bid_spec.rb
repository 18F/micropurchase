require 'rails_helper'

RSpec.describe PlaceBid do
  let(:place_bid) { PlaceBid.new(auction, params) }
  let(:place_second_bid) { PlaceBid.new(auction2, second_params) }
  let(:current_user) { FactoryGirl.create(:user) }
  let(:second_user) { FactoryGirl.create(:user) }
  let(:amount) { 1005 }
  let(:params) do
    {
      auction_id: auction_id,
      bid: {
        amount: amount
      }
    }
  end
  let(:second_amount) { 1000 }
  let(:second_params) do
    {
      auction_id: auction_id,
      bid: {
        amount: second_amount
      }
    }
  end
  let(:auction_id) { auction.id }
  let(:ar_auction) do
    FactoryGirl.create(:auction,
                       :multi_bid,
                       start_datetime: Time.now - 3.days,
                       end_datetime: Time.now + 7.days)
  end
  let(:auction) { Policy::Auction.factory(ar_auction, current_user) }

  # this awkward construction is to bypass caching in the AR model, etc.
  let(:auction2) { Policy::Auction.factory(Auction.find(ar_auction.id), current_user) }

  context 'when the auction is single-bid' do
    let(:ar_auction) do
      FactoryGirl.create(:auction,
                         :single_bid,
                         :with_bidders,
                         start_datetime: Time.now - 3.days,
                         end_datetime: Time.now + 7.days)
    end
    let(:second_user_auction) { Policy::Auction.factory(ar_auction, second_user) }

    it 'should reject bids when the user has already bid on the given auction' do
      expect do
        place_bid.perform
        place_second_bid.perform
      end.to raise_error(UnauthorizedError)
    end

    it 'should allow tie bids' do
      params = {
        auction_id: auction_id,
        bid: {
          amount: 10
        }
      }
      expect do
        PlaceBid.new(auction, params).perform
        PlaceBid.new(second_user_auction, params).perform
      end.to_not raise_error
    end
  end

  context 'when the auction has expired' do
    let(:ar_auction) do
      FactoryGirl.create(:auction,
                         start_datetime: Time.now - 5.days,
                         end_datetime: Time.now - 3.day)
    end

    it 'should raise an authorization error (because we have that baked in)' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the auction has not started yet' do
    let(:ar_auction) do
      FactoryGirl.create(:auction,
                         start_datetime: Time.now + 5.days,
                         end_datetime: Time.now + 7.days)
    end

    it 'should raise an authorization error (same as above)' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is in increments small than one dollar' do
    let(:amount) { 1_000.99 }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is above the starting price' do
    let(:amount) { 3600 }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is above the current bid price' do
    let(:amount) { 405 }

    it 'should raise an authorization error' do
      FactoryGirl.create(:bid, auction: ar_auction, amount: amount - 5)
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is above the auction start price and there are no bids' do
    let(:amount) { 3600 }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is equal to the current bid price' do
    let(:amount) { 400 }

    it 'should raise an authorization error' do
      FactoryGirl.create(:bid, auction: ar_auction, amount: amount)
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is equal to the auction start price and there are no bids' do
    let(:amount) { 3500 }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is negative' do
    let(:amount) { '-10' }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the bid amount is 0' do
    let(:amount) { 0 }

    it 'should raise an authorization error' do
      expect { place_bid.perform }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the amount has a comma' do
    let(:bid)    { place_bid.bid }
    let(:amount) { '1,000' }

    it 'should disregard the comma' do
      place_bid.perform
      expect(bid.amount).to eq(1000)
    end
  end

  context 'when all the data is great' do
    let(:bid) { place_bid.bid }

    it 'creates a bid' do
      expect { place_bid.perform }.to change { Bid.count }.by(1)
      expect(bid.auction_id).to eq(auction.id)
      expect(bid.bidder_id).to eq(current_user.id)
    end

    it 'rounds the amount to two decimal places' do
      place_bid.perform
      bid.reload
      expect(bid.amount).to eq(1005)
    end
  end
end
