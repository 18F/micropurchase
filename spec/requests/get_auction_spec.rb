require 'rails_helper'

describe 'GET /auctions/:id' do
  include RequestHelpers

  context 'when the API key is invalid' do
    it 'ignores the key and returns a 200 HTTP response' do
      login
      api_key = FakeGitHub::INVALID_API_KEY
      auction = create(:auction, :with_bidders)

      get auction_path(auction), nil, headers(api_key)

      expect(response.status).to eq 200
    end
  end

  context 'when the API key is missing' do
    it 'returns a 200 HTTP response' do
      login
      api_key = nil
      auction = create(:auction, :with_bidders)

      get auction_path(auction), nil, headers(api_key)

      expect(response.status).to eq 200
    end
  end

  context 'when the API key is valid' do
    it 'returns a 200 HTTP response' do
      login
      auction = create(:auction, :with_bidders)

      get auction_path(auction), nil, headers

      expect(response.status).to eq 200
    end

    it 'returns a valid auction' do
      login
      auction = create(:auction, :with_bidders)

      get auction_path(auction), nil, headers

      expect(response).to match_response_schema('auction')
    end

    it 'returns iso8601 dates' do
      login
      auction = create(:auction, :with_bidders)

      get auction_path(auction), nil, headers

      expect(json_auction['created_at']).to be_iso8601
      expect(json_auction['updated_at']).to be_iso8601
      expect(json_auction['start_datetime']).to be_iso8601
      expect(json_auction['end_datetime']).to be_iso8601
    end

    context 'when the auction is single bid' do
      context 'and the auction is running' do
        it 'veils all bids' do
          login
          auction = create(:auction, :running, :single_bid, :with_bidders)

          get auction_path(auction), nil, headers

          expect(json_bids).to be_empty
        end

        context 'and the authenticated user is one of the bidders' do
          it 'does not veil the bids from the authenticated user' do
            user = create(:user)
            login(user)
            auction = create(:auction, :running, :single_bid, :with_bidders)
            create(:bid, auction: auction, bidder: user)

            get auction_path(auction), nil, headers
            bidder = authenticated_users_bid(user)['bidder']

            expect(authenticated_users_bid(user)['bidder_id']).to_not be_nil
            expect(bidder['id']).to eq user.id
            expect(bidder['name']).to eq user.name
            expect(bidder['duns_number']).to eq user.duns_number
            expect(bidder['github_id']).to eq user.github_id
            expect(bidder['created_at']).to eq (user.created_at).to_datetime.iso8601
            expect(bidder['updated_at']).to eq (user.updated_at).to_datetime.iso8601
            expect(bidder['sam_status']).to eq user.sam_status.to_s
          end

          it 'veils the bids not created by the authenticated user' do
            user = create(:user)
            login(user)
            auction = create(:auction, :running, :single_bid, :with_bidders)
            create(:bid, auction: auction, bidder: user)

            get auction_path(auction), nil, headers

            expect(json_bids).to include(authenticated_users_bid(user))
            expect(json_bids.length).to eq(1)
          end
        end
      end

      context 'and the auction is closed' do
        it 'unveils all bids information' do
          login
          auction = create(:auction, :closed, :single_bid, :with_bidders)

          get auction_path(auction), nil, headers

          json_bids.each do |bid|
            expect(bid['bidder_id']).to_not be_nil
            bidder = bid['bidder']
            expect(bidder['id']).to_not be_nil
            expect(bidder['name']).to_not be_nil
            expect(bidder['duns_number']).to_not be_nil
            expect(bidder['github_id']).to_not be_nil
            expect(bidder['created_at']).to_not be_nil
            expect(bidder['updated_at']).to_not be_nil
            expect(bidder['sam_status']).to_not be_nil
          end
        end
      end
    end

    context 'when the auction is mult-bid' do
      context 'and the auction is running' do
        it 'veils all bidder information' do
          login
          auction = create(:auction, :running, :with_bidders)

          get auction_path(auction), nil, headers

          json_bids.each do |bid|
            expect(bid['bidder_id']).to be_nil
            bidder = bid['bidder']
            expect(bidder['id']).to be_nil
            expect(bidder['name']).to be_nil
            expect(bidder['duns_number']).to be_nil
            expect(bidder['github_id']).to be_nil
            expect(bidder['created_at']).to be_nil
            expect(bidder['updated_at']).to be_nil
            expect(bidder['sam_status']).to be_nil
          end
        end

        context 'and the authenticated user is one of the bidders' do
          it 'does not veil the bids from the authenticated user' do
            user = create(:user)
            login(user)
            auction = create(:auction, :running, bidder_ids: [user.id])

            get auction_path(auction), nil, headers

            expect(authenticated_users_bid(user)['bidder_id']).to_not be_nil
            bidder = authenticated_users_bid(user)['bidder']

            expect(bidder['id']).to_not be_nil
            expect(bidder['name']).to_not be_nil
            expect(bidder['duns_number']).to_not be_nil
            expect(bidder['github_id']).to_not be_nil
            expect(bidder['created_at']).to_not be_nil
            expect(bidder['updated_at']).to_not be_nil
            expect(bidder['sam_status']).to_not be_nil
          end

          it 'veils the bids not created by the authenticated user' do
            user = create(:user)
            login(user)
            auction = create(:auction, :running, bidder_ids: [user.id])

            get auction_path(auction), nil, headers

            all_the_other_bids(user).each do |bid|
              expect(bid['bidder_id']).to be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to be_nil
              expect(bidder['name']).to be_nil
              expect(bidder['duns_number']).to be_nil
              expect(bidder['github_id']).to be_nil
              expect(bidder['created_at']).to be_nil
              expect(bidder['updated_at']).to be_nil
              expect(bidder['sam_status']).to be_nil
            end
          end
        end
      end

      context 'and the auction is closed' do
        it 'unveils all bidder information' do
          login
          auction = create(:auction, :closed, :with_bidders)

          get auction_path(auction), nil, headers

          json_bids.each do |bid|
            expect(bid['bidder_id']).to_not be_nil
            bidder = bid['bidder']
            expect(bidder['id']).to_not be_nil
            expect(bidder['name']).to_not be_nil
            expect(bidder['duns_number']).to_not be_nil
            expect(bidder['github_id']).to_not be_nil
            expect(bidder['created_at']).to_not be_nil
            expect(bidder['updated_at']).to_not be_nil
            expect(bidder['sam_status']).to_not be_nil
          end
        end
      end
    end
  end

  def authenticated_users_bid(user)
    json_bids.find { |b| b['bidder_id'] == user.id }
  end

  def all_the_other_bids(user)
    json_bids.select { |b| b['bidder_id'] != user.id }
  end

  def json_bids
    json_auction['bids']
  end

  def json_auction
    json_response['auction']
  end
end
