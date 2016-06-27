require 'rails_helper'

describe WinnersViewModel do
  describe '#vendors_with_bids_count' do
    it "returns number of unique vendors who have submitted bids" do
      auction = create(:auction)
      user = create(:user)
      second_user = create(:user)
      _third_user = create(:user)
      create(:bid, auction: auction, bidder: user)
      second_auction = create(:auction)
      create(:bid, auction: second_auction, bidder: user)
      create(:bid, auction: second_auction, bidder: second_user)

      expect(WinnersViewModel.new.vendors_with_bids_count).to eq 2
    end
  end

  describe '#average_bids_per_auction' do
    context 'there are completed auctions' do
      it 'returns correct number' do
        create(:auction, :complete_and_successful)

        expect(WinnersViewModel.new.average_bids_per_auction).to eq 2
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(WinnersViewModel.new.average_bids_per_auction).to eq 'n/a'
      end
    end
  end

  describe '#average_auction_length' do
    context 'there are completed auctions' do
      it 'returns correct number' do
        create(
          :auction,
          :complete_and_successful,
          started_at: 3.days.ago,
          ended_at: Time.current
        )

        expect(WinnersViewModel.new.average_auction_length).to eq "3 days"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(WinnersViewModel.new.average_auction_length).to eq 'n/a'
      end
    end
  end

  describe '#average_winning_bid' do
    context 'there are completed auctions' do
      it 'returns correct amount' do
        auction = create(:auction, :complete_and_successful)
        create(:bid, amount: 3, auction: auction)

        expect(WinnersViewModel.new.average_winning_bid).to eq "$3.00"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(WinnersViewModel.new.average_winning_bid).to eq 'n/a'
      end
    end
  end
end
