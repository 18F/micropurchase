require 'rails_helper'

describe 'API bid requests' do
  include RequestHelpers

  before do
    stub_github('/user') do
      github_response_for_user(user)
    end
  end
  let(:user) { create(:user, sam_status: :sam_accepted) }
  let(:headers) do
    {
      'HTTP_ACCEPT' => 'text/x-json',
      'HTTP_API_KEY' => api_key
    }
  end
  let(:json_response) { JSON.parse(response.body) }
  let(:params) do
    {
      bid: {
        amount: bid_amount
      }
    }
  end
  let(:second_params) do
    {
      bid: {
        amount: second_bid_amount
      }
    }
  end
  let(:status) { response.status }

  describe 'POST /auctions/:auction_id/bids' do
    let(:json_bid) { json_response['bid'] }

    context 'when the API key is missing' do
      let(:api_key) { nil }
      let(:auction) { create(:auction, :with_bids) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        post api_v0_auction_bids_path(auction), params, headers
        expect(json_response['error']).to eq('User not found')
      end

      it 'should not create a bid' do
        expect do
          post api_v0_auction_bids_path(auction), params, headers
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHubApi::INVALID_API_KEY }
      let(:auction) { create(:auction, :with_bids) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        post api_v0_auction_bids_path(auction), params, headers
        expect(json_response['error']).to eq('User not found')
      end

      it 'should not create a bid' do
        expect do
          post api_v0_auction_bids_path(auction), params, headers
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the auction has ended' do
      let(:api_key) { FakeGitHubApi::VALID_API_KEY }
      let(:auction) { create(:auction, :closed, :with_bids) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        post api_v0_auction_bids_path(auction), params, headers
        expect(json_response['error']).to eq(
          'You are not allowed to bid on this auction'
        )
      end

      it 'should not create a bid' do
        expect do
          post api_v0_auction_bids_path(auction), params, headers
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the auction has not yet started' do
      let(:api_key) { FakeGitHubApi::VALID_API_KEY }
      let(:auction) { create(:auction, :future, :with_bids) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        post api_v0_auction_bids_path(auction), params, headers
        expect(json_response['error']).to eq(
          'You are not allowed to bid on this auction'
        )
      end

      it 'should not create a bid' do
        expect do
          post api_v0_auction_bids_path(auction), params, headers
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the auction has bids' do
      let(:api_key) { FakeGitHubApi::VALID_API_KEY }
      let(:auction) { create(:auction, :with_bids) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end

      context 'and the bid amount is the lowest' do
        let(:bid_amount) { current_auction_price - 10 }

        it 'creates a new bid' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_bid['amount']).to eq(bid_amount)
          expect(json_bid['bidder_id']).to eq(user.id)
        end

        it 'returns a 200 status code' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(status).to eq(200)
        end

        it 'should create a bid from the API source' do
          expect do
            post api_v0_auction_bids_path(auction), params, headers
          end.to change { auction.bids.count }.by(1)

          new_bid = auction.bids.order('created_at DESC').first

          expect(new_bid.amount).to eq(bid_amount)
          expect(new_bid.bidder).to eq(user)
          expect(new_bid.via).to eq('api')
        end
      end

      context 'when the auction start price is between the micropurchase and SAT threshold' do
        let(:auction) { create(:auction, :between_micropurchase_and_sat_threshold, :with_bids) }
        let(:bid_amount) { current_auction_price - 10 }

        context 'and the vendor is not small business' do
          let(:user) { create(:user, :not_small_business) }

          it 'returns a json error' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(json_response['error']).to eq('You are not allowed to bid on this auction')
          end

          it 'returns a 403 status code' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(status).to eq(403)
          end

          it 'does not create a bid' do
            expect do
              post api_v0_auction_bids_path(auction), params, headers
            end.to_not change { auction.bids.count }
          end
        end
      end

      context 'when the auction is reverse' do
        let(:auction) { create(:auction, :reverse, :with_bids) }

        context 'and the bid amount is not the lowest' do
          let(:bid_amount) { current_auction_price + 10 }

          it 'returns a json error' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(json_response['error']).to eq('Bids cannot be greater than the current max bid')
          end

          it 'returns a 403 status code' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(status).to eq(403)
          end

          it 'should not create a bid' do
            expect do
              post api_v0_auction_bids_path(auction), params, headers
            end.to_not change { auction.bids.count }
          end
        end
      end

      context 'when the auction is sealed-bid' do
        let(:auction) { create(:auction, :with_bids, :sealed_bid) }

        context 'and the bid amount is not the lowest' do
          let(:amount) { current_auction_price + 10 }
          let(:bid_amount) { amount }

          it 'returns a 200 status code' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(status).to eq(200)
          end

          it 'returns the right amount' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(json_response['bid']['amount']).to eq(amount)
          end
        end

        context 'and the bidder has not yet bid on this auction' do
          let(:bid_amount) { current_auction_price - 10 }

          it 'creates a new bid' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(json_bid['amount']).to eq(bid_amount)
            expect(json_bid['bidder_id']).to eq(user.id)
          end

          it 'returns a 200 status code' do
            post api_v0_auction_bids_path(auction), params, headers
            expect(status).to eq(200)
          end

          it 'should create a bid from the API source' do
            expect do
              post api_v0_auction_bids_path(auction), params, headers
            end.to change { auction.bids.count }.by(1)

            new_bid = auction.bids.order('created_at DESC').first
            expect(new_bid.amount).to eq(bid_amount)
            expect(new_bid.bidder).to eq(user)
            expect(new_bid.via).to eq('api')
          end
        end

        context 'and the bidder has already bid on this auction' do
          let(:bid_amount) { current_auction_price - 10 }
          let(:second_bid_amount) { bid_amount - 10 }

          it 'returns a 403 status code' do
            post api_v0_auction_bids_path(auction), params, headers

            expect do
              post api_v0_auction_bids_path(auction), second_params, headers
            end.to_not change { auction.bids.count }

            expect(status).to eq(403)
            expect(json_response).to have_key('error')
            expect(json_response['error']).to eq('You are not allowed to bid on this auction')
          end
        end
      end

      context 'and the user has a rejected #sam_status' do
        let(:user) { create(:user, sam_status: :sam_rejected) }
        let(:bid_amount) { current_auction_price - 10 }

        it 'returns a json error' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_response['error']).to eq(
            'You are not allowed to bid on this auction'
          )
        end

        it 'returns a 403 status code' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(status).to eq(403)
        end

        it 'should not create a bid' do
          expect do
            post api_v0_auction_bids_path(auction), params, headers
          end.to_not change { auction.bids.count }
        end
      end

      context 'and the user has a pending #sam_status' do
        let(:user) { create(:user, sam_status: :sam_pending) }
        let(:bid_amount) { current_auction_price - 10 }

        it 'returns a json error' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_response['error']).to eq(
            'You are not allowed to bid on this auction'
          )
        end

        it 'returns a 403 status code' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(status).to eq(403)
        end

        it 'should not create a bid' do
          expect do
            post api_v0_auction_bids_path(auction), params, headers
          end.to_not change { auction.bids.count }
        end
      end

      context 'and the bid amount is a float' do
        let(:bid_amount) { (current_auction_price - 10).to_f }

        it 'ignores the floatiness' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_bid['amount']).to eq(bid_amount)
        end
      end

      context 'and the bid amount is letters' do
        let(:bid_amount) { 'clearly not a valid bid' }

        it 'returns a json error' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_response['error']).to eq('Bid amount out of range')
        end

        it 'returns a 403 status code' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(status).to eq(403)
        end
      end

      context 'and the bid amount is a negative number' do
        let(:bid_amount) { -1000 }

        it 'returns a json error' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(json_response['error']).to eq('Bid amount out of range')
        end

        it 'returns a 403 status code' do
          post api_v0_auction_bids_path(auction), params, headers
          expect(status).to eq(403)
        end

        it 'should not create a bid' do
          expect do
            post api_v0_auction_bids_path(auction), params, headers
          end.to_not change { auction.bids.count }
        end
      end
    end
  end
end
