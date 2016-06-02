require 'rails_helper'

describe PlaceBidValidator do
  describe '#validate' do
    it 'validates that the bidder is sam accepted' do
      user = create(:user, sam_status: :sam_rejected)
      bid = Bid.new(bidder: user, amount: valid_amount, auction: auction)

      PlaceBidValidator.new.validate(bid)

      expect(bid.errors.full_messages).to include(
        'You are not allowed to bid on this auction'
      )
    end

    it 'validates that the auction is availble' do
      auction = build(:auction, :future)
      bid = Bid.new(bidder: user, amount: valid_amount, auction: auction)

      PlaceBidValidator.new.validate(bid)

      expect(bid.errors.full_messages).to include(
        'You are not allowed to bid on this auction'
      )
    end

    it 'validates that the bid amount is less than the max allowed bid' do
      auction = build(:auction, :multi_bid)
      bid = create(:bid, auction: auction, amount: 150)
      bid = Bid.new(bidder: user, amount: 155, auction: auction)

      PlaceBidValidator.new.validate(bid)

      expect(bid.errors.full_messages).to include(
        'Bids cannot be greater than the current max bid'
      )
    end

    it 'validates that the bid amount is greater than or equal to zero' do
      bid = Bid.new(bidder: user, amount: -2, auction: auction)

      PlaceBidValidator.new.validate(bid)

      expect(bid.errors.full_messages).to include(
        'Bid amount out of range'
      )
    end
  end

  def auction
    @_auction ||= build(:auction)
  end

  def user
    @_user ||= build(:user, sam_status: :sam_accepted)
  end

  def valid_amount
    100
  end
end
