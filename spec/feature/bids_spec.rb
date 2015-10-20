require_relative '../feature_helper'

RSpec.describe 'Bids, REST style' do
  let(:current_bidder) { User.create(github_id: current_user_uid)}
  let(:auction) { Auction.create(title: 'Refactor this disaster') }

  describe '/bids' do
    let!(:bids) {
      [
        Bid.create(bidder_id: current_bidder.id, amount: 1000),
        Bid.create(bidder_id: current_bidder.id + 1000, amount: 2000)
      ]
    }

    it 'shows my bids' do
      get '/bids', {}, session_authentication(current_bidder.id)
      expect(last_response.body).to include('$1,000')
    end

    it 'doesnt show other peoples bids' do
      get '/bids', {}, session_authentication(current_bidder.id)
      expect(last_response.body).not_to include('$2,000')
    end
  end
end
