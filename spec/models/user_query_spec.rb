require 'rails_helper'

describe UserQuery do
  describe '#with_bids' do
    it 'returns users with bids' do
      _user_without_bids = create(:user)
      user_with_bid = create(:user, :with_bid)

      expect(UserQuery.new.with_bids).to match_array([user_with_bid])
    end
  end

  describe '#small_business' do
    it 'returns users that are small businesses' do
      _not_small_business = create(:user, :not_small_business)
      small_business = create(:user, :small_business)

      expect(UserQuery.new.small_business).to match_array([small_business])
    end
  end

  describe '#in_sam' do
    it 'returns users with sam_status of sam_accepted' do
      _not_sam_accepted = create(:user)
      sam_accepted = create(:user, :sam_accepted)

      expect(UserQuery.new.in_sam).to match_array([sam_accepted])
    end
  end
end
