require 'rails_helper'

describe Auction do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    context 'on create' do
      it { should validate_presence_of(:end_datetime) }
      it { should validate_presence_of(:start_datetime) }
      it { should validate_presence_of(:start_price) }
      it { should validate_presence_of(:title) }
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

    context 'when set to published' do
      it 'validates presence of summary' do
        auction = create(:auction, published: :unpublished)

        auction.published = :published
        auction.summary = nil

        expect(auction).to be_invalid
      end

      it 'validates presence of delivery deadline' do
        auction = create(:auction, published: :unpublished)

        auction.published = :published
        auction.delivery_deadline = nil

        expect(auction).to be_invalid
      end

      it 'validates presence of description' do
        auction = create(:auction, published: :unpublished)

        auction.published = :published
        auction.description = nil

        expect(auction).to be_invalid
      end
    end
  end

  describe "#lowest_bid" do
    context "multiple bids" do
      it "returns bid with lowest amount" do
        auction = FactoryGirl.create(:auction)
        low_bid = FactoryGirl.create(:bid, auction: auction, amount: 1)
        _high = FactoryGirl.create(:bid, auction: auction, amount: 10000)

        expect(auction.lowest_bid).to eq(low_bid)
      end
    end

    context "no bids" do
      it "returns nil" do
        auction = FactoryGirl.create(:auction)

        expect(auction.lowest_bid).to be_nil
      end
    end

    context "multiple bids with same amount" do
      it "returns first created bid" do
        auction = FactoryGirl.create(:auction)
        _second_bid = FactoryGirl.create(:bid, auction: auction, created_at: Time.current, amount: 1)
        first_bid = FactoryGirl.create(:bid, auction: auction, created_at: 1.hour.ago, amount: 1)

        expect(auction.lowest_bid).to eq(first_bid)
      end
    end
  end
end
