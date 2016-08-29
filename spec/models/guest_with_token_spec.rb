require 'rails_helper'

describe GuestWithToken do
  describe 'initialize' do
    it 'should load the auction associated with the token' do
      auction = FactoryGirl.create(:auction)
      guest = GuestWithToken.new(auction.token)

      expect(guest).to_not be_nil
      expect(guest.auction).to eq(auction)
    end

    it 'should raise an exception if there is no auction' do
      expect { GuestWithToken.new('foo') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
