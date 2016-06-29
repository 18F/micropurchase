require 'rails_helper'

describe InsightsViewModel do
  describe '#unique_bidders_per_auction' do
    it "returns average number of unique vendors who have submitted bids" do
      _auction_with_two_unique_bidders =
        create(:auction, :completed, bids: [create(:bid), create(:bid)])
      _auction_with_one_unique_bidder =
        create(:auction, :completed, bids: [create(:bid)])
      user = create(:user)
      auction_with_three_unique_bidders = create(:auction, :completed)
      create(:bid, auction: auction_with_three_unique_bidders, bidder: user)
      create(:bid, auction: auction_with_three_unique_bidders, bidder: user)
      create(:bid, auction: auction_with_three_unique_bidders)
      create(:bid, auction: auction_with_three_unique_bidders)

      expect(InsightsViewModel.new.unique_bidders_per_auction).to eq 2
    end
  end

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

      expect(InsightsViewModel.new.vendors_with_bids_count).to eq 2
    end
  end

  describe '#average_bids_per_auction' do
    context 'there are completed auctions' do
      it 'returns correct number' do
        create(:auction, :complete_and_successful)

        expect(InsightsViewModel.new.average_bids_per_auction).to eq 2
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(InsightsViewModel.new.average_bids_per_auction).to eq 'n/a'
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

        expect(InsightsViewModel.new.average_auction_length).to eq "3 days"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(InsightsViewModel.new.average_auction_length).to eq 'n/a'
      end
    end
  end

  describe '#average_winning_bid' do
    context 'there are completed auctions' do
      it 'returns correct amount' do
        auction = create(:auction, :complete_and_successful)
        create(:bid, amount: 3, auction: auction)

        expect(InsightsViewModel.new.average_winning_bid).to eq "$3.00"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(InsightsViewModel.new.average_winning_bid).to eq 'n/a'
      end
    end
  end
end
