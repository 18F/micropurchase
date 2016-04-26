require 'rails_helper'

RSpec.describe AuctionsController do
  before do
    stub_github('/user') do
      github_response_for_user(user)
    end
  end
  let(:user) { FactoryGirl.create(:user, sam_status: :sam_accepted) }
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
    before do
      post auction_bids_path(auction), params, headers
    end
    let(:json_bid) { json_response['bid'] }

    context 'when the API key is missing' do
      let(:api_key) { nil }
      let(:auction) { FactoryGirl.create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        expect(json_response['error']).to eq('User not found')
      end

      it 'returns a 404 status code' do
        expect(status).to eq(404)
      end
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHub::INVALID_API_KEY }
      let(:auction) { FactoryGirl.create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        expect(json_response['error']).to eq('User not found')
      end

      it 'returns a 404 status code' do
        expect(status).to eq(404)
      end
    end

    context 'when the auction has ended' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { FactoryGirl.create(:auction, :closed, :with_bidders) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        expect(json_response['error']).to eq('Auction not available')
      end

      it 'returns a 403 status code' do
        expect(status).to eq(403)
      end
    end

    context 'when the auction has not yet started' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { FactoryGirl.create(:auction, :future, :with_bidders) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a json error' do
        expect(json_response['error']).to eq('Auction not available')
      end

      it 'returns a 403 status code' do
        expect(status).to eq(403)
      end
    end

    context 'when the auction is running' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { FactoryGirl.create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by {|b| b.amount}.first.amount
      end

      context 'and the bid amount is the lowest' do
        let(:bid_amount) { current_auction_price - 10 }

        it 'creates a new bid' do
          expect(json_bid['amount']).to eq(bid_amount)
          expect(json_bid['bidder_id']).to eq(user.id)
        end

        it 'returns a 200 status code' do
          expect(status).to eq(200)
        end
      end

      context 'when the auction is multi-bid' do
        let(:auction) { FactoryGirl.create(:auction, :running, :multi_bid) }

        context 'and the bid amount is not the lowest' do
          let(:bid_amount) { current_auction_price + 10 }

          it 'returns a json error' do
            expect(json_response['error']).to eq('Bids cannot be greater than the current max bid')
          end

          it 'returns a 403 status code' do
            expect(status).to eq(403)
          end
        end
      end

      context 'when the auction is single-bid' do
        let(:auction) { FactoryGirl.create(:auction, :running, :single_bid) }

        context 'and the bid amount is not the lowest' do
          let(:amount) { current_auction_price + 10 }
          let(:bid_amount) { amount }

          it 'returns a 200 status code' do
            expect(status).to eq(200)
          end

          it 'returns the right amount' do
            expect(json_response['bid']['amount']).to eq(amount)
          end
        end

        context 'and the bidder has not yet bid on this auction' do
          let(:bid_amount) { current_auction_price - 10 }

          it 'creates a new bid' do
            expect(json_bid['amount']).to eq(bid_amount)
            expect(json_bid['bidder_id']).to eq(user.id)
          end

          it 'returns a 200 status code' do
            expect(status).to eq(200)
          end
        end

        context 'and the bidder has already bid on this auction' do
          let(:bid_amount) { current_auction_price - 10 }
          let(:second_bid_amount) { bid_amount - 10 }

          it 'returns a 403 status code' do
            post auction_bids_path(auction), second_params, headers

            expect(status).to eq(403)
            expect(json_response).to have_key('error')
            expect(json_response['error']).to eq('You can only bid once in a single-bid auction.')
          end
        end
      end


      context 'and the user has a rejected #sam_status' do
        let(:user) { FactoryGirl.create(:user, sam_status: :sam_rejected) }
        let(:bid_amount) { current_auction_price - 10 }

        it 'returns a json error' do
          expect(json_response['error']).to eq('You must have a valid SAM.gov account to place a bid')
        end

        it 'returns a 403 status code' do
          expect(status).to eq(403)
        end
      end

      context 'and the user has a pending #sam_status' do
        let(:user) { FactoryGirl.create(:user, sam_status: :sam_pending) }
        let(:bid_amount) { current_auction_price - 10 }

        it 'returns a json error' do
          expect(json_response['error']).to eq('You must have a valid SAM.gov account to place a bid')
        end

        it 'returns a 403 status code' do
          expect(status).to eq(403)
        end
      end

      context 'and the bid amount is a float' do
        let(:bid_amount) { (current_auction_price - 10).to_f }

        it 'ignores the floatiness' do
          expect(json_bid['amount']).to eq(bid_amount)
        end
      end

      context 'and the bid amount is letters' do
        let(:bid_amount) { 'clearly not a valid bid' }

        it 'returns a json error' do
          expect(json_response['error']).to eq('Bid amount out of range')
        end

        it 'returns a 403 status code' do
          expect(status).to eq(403)
        end
      end

      context 'and the bid amount is a negative number' do
        let(:bid_amount) { -1000 }

        it 'returns a json error' do
          expect(json_response['error']).to eq('Bid amount out of range')
        end

        it 'returns a 403 status code' do
          expect(status).to eq(403)
        end
      end

      context 'and the bid amount contains cents' do
        let(:bid_amount) { 1.99 }

        it 'returns a json error' do
          expect(json_response['error']).to eq('Bids must be in increments of one dollar')
        end

        it 'returns a 403 status code' do
          expect(status).to eq(403)
        end
      end
    end
  end
end
