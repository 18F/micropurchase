require 'rails_helper'

describe Auction do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    context 'on create' do
      it { should validate_presence_of(:billable_to) }
      it { should validate_presence_of(:ended_at) }
      it { should validate_presence_of(:started_at) }
      it { should validate_presence_of(:start_price) }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:user) }
      it { should validate_presence_of(:purchase_card) }
      it do
        should_not allow_values(
          ENV['C2_HOST'], 'http://www.example.com'
        ).for(:c2_proposal_url)
      end
      it { should allow_value("#{ENV['C2_HOST']}/proposals/123").for(:c2_proposal_url) }
      it { should allow_value('').for(:c2_proposal_url) }

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
        auction.delivery_due_at = nil

        expect(auction).to be_invalid
      end

      it 'validates presence of description' do
        auction = create(:auction, published: :unpublished)

        auction.published = :published
        auction.description = nil

        expect(auction).to be_invalid
      end

      it 'validates presence of c2_status' do
        auction = create(:auction, :unpublished, purchase_card: :default)

        auction.published = :published

        expect(auction).to be_invalid
        expect(auction.errors.messages).to eq(c2_status: [" is not approved."])
      end
    end
  end

  describe '#sorted_skill_names' do
    it 'returns alpha ordered skills' do
      c_skill = create(:skill, name: 'c')
      a_skill = create(:skill, name: 'a')
      b_skill = create(:skill, name: 'b')
      auction = create(:auction)
      auction.skills << [c_skill, a_skill, b_skill]

      expect(auction.sorted_skill_names).to eq(%w(a b c))
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
