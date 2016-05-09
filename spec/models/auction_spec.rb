require 'rails_helper'

describe Auction do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user) }

    describe "starting price validations" do
      context "creator is admin" do
        it "does not allow auction to have start price above 3500" do
          user = create(:admin_user)
          auction = build(:auction, user: user, start_price: 5000)

          expect(auction).not_to be_valid
        end
      end

      context "creator is contracting officer" do
        it "allows auctions to have a start price over 3500" do
          user = create(:contracting_officer)
          auction = build(:auction, user: user, start_price: 5000)

          expect(auction).to be_valid
        end
      end
    end
  end

  describe "#html_summary" do
    context "summary is nil" do
      it 'should return an empty string if the summary is blank' do
        auction = build(:auction, summary: nil)
        expect(auction.html_summary).to be_blank
      end
    end

    context "summary contains markdown" do
      it 'renders markdown as HTML with autolinks' do
        summary = 'This is **bold** text with link http://18f.gov anytime'

        auction = build(:auction, summary: summary)

        expect(auction.html_summary).to match('<strong>bold</strong>')
        expect(auction.html_summary).to match('<a href="http://18f.gov">http://18f.gov</a>')
      end
    end
  end

  describe '#show_bid_button?' do
    context 'no user' do
      it 'is true' do
        auction = build(:auction)

        expect(auction.show_bid_button?(nil)).to eq true
      end
    end

    context 'user does not have verified SAM account' do
      it 'is false' do
        user = create(:user, sam_status: :sam_pending)
        auction = build(:auction)

        expect(auction.show_bid_button?(user)).to eq false
      end
    end
  end

  describe '#user_is_bidder?' do
    context 'user placed bid on auction' do
      it 'is true' do
        auction = build(:auction)
        user = create(:user)
        create(:bid, auction: auction, bidder: user)

        expect(auction.user_is_bidder?(user)).to eq true
      end
    end

    context 'user has not placed a bid' do
      it 'is false' do
        auction = build(:auction)
        user = create(:user)

        expect(auction.user_is_bidder?(user)).to eq false
      end
    end
  end

  describe '#user_is_winning_bidder?' do
    context 'when the user is currently the winner' do
      it 'should return true' do
        auction = build(:auction)
        user = create(:user)
        create(:bid, auction: auction, bidder: user)

        expect(auction.user_is_winning_bidder?(user)).to eq true
      end
    end

    context 'when the user is not the current winner' do
      it 'should return false' do
        auction = create(:auction)
        user = create(:user)
        create(:bid, amount: 100, auction: auction, bidder: user)
        create(:bid, amount: 50, auction: auction)

        expect(auction.user_is_winning_bidder?(user)).to eq false
      end
    end
  end

  describe "#lowest_bid" do
    context "multiple bids" do
      it "returns bid with lowest amount" do
        auction = create(:auction)
        low_bid = create(:bid, auction: auction, amount: 1)
        _high = create(:bid, auction: auction, amount: 10000)

        expect(auction.lowest_bid).to eq(low_bid)
      end
    end

    context "no bids" do
      it "returns nil" do
        auction = create(:auction)

        expect(auction.lowest_bid).to be_nil
      end
    end

    context "multiple bids with same amount" do
      it "returns first created bid" do
        auction = create(:auction)
        _second_bid = create(:bid, auction: auction, created_at: Time.current, amount: 1)
        first_bid = create(:bid, auction: auction, created_at: 1.hour.ago, amount: 1)

        expect(auction.lowest_bid).to eq(first_bid)
      end
    end
  end
end
