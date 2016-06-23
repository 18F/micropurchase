require 'rails_helper'

RSpec.describe 'Swagger spec', type: :apivore, order: :defined do
  subject { Apivore::SwaggerChecker.instance_for('/api/v0/swagger.json') }
  include RequestHelpers

  context 'GET /auctions' do
    context 'when the API key is invalid' do
      it 'ignores the key and returns a 200 HTTP response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY

        expect(subject).to validate(:get,
                                    '/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the API key is missing' do
      it 'returns a 200 HTTP response' do
        login
        api_key = nil

        expect(subject).to validate(:get,
                                    '/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the API key is valid' do
      it 'returns a 200 HTTP response' do
        login
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end

      it 'returns valid auctions' do
        login
        create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end
    end
  end

  context 'GET /auctions/{id}' do
    context 'when the API key is invalid' do
      it 'ignores the key and returns a 200 HTTP response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY
        auction = create(:auction, :with_bidders)

        expect(subject).to validate(:get,
                                    '/auctions/{id}',
                                    200,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end
    end

    context 'when the API key is missing' do
      it 'returns a 200 HTTP response' do
        login
        api_key = nil
        auction = create(:auction, :with_bidders)

        expect(subject).to validate(:get,
                                    '/auctions/{id}',
                                    200,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end
    end

    context 'when the API key is valid' do
      it 'returns a 200 HTTP response' do
        login
        auction = create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/auctions/{id}',
                                    200,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end

      context 'winning bid not present' do
        it 'returns a valid auction response' do
          login
          auction = create(:auction, :available, :sealed_bid)
          _bid = create(:bid, auction: auction)
          api_key = FakeGitHub::VALID_API_KEY

          expect(subject).to validate(:get,
                                      '/auctions/{id}',
                                      200,
                                      "id" => auction.id, "_headers" => headers(api_key))
        end
      end
    end

    context 'when the auction is not found' do
      it 'returns a 404 HTTP response' do
        login
        auction = create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/auctions/{id}',
                                    404,
                                    "id" => auction.id+10, "_headers" => headers(api_key))
      end
    end
  end

  context 'posting a new bid' do
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
    let(:body) do
      {
        bid: {
          amount: bid_amount
        }
      }
    end
    let(:second_body) do
      {
        bid: {
          amount: second_bid_amount
        }
      }
    end
    let(:status) { response.status }

    context 'when the API key is missing' do
      let(:api_key) { nil }
      let(:auction) { create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a 403 error and does not create a bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      403,
                                      'id' => auction.id, '_headers' => headers,
                                      '_data' => body)
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHub::INVALID_API_KEY }
      let(:auction) { create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a 403 error and does not create a bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      403,
                                      'id' => auction.id, '_headers' => headers,
                                      '_data' => body)
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the auction is not found' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:bid_amount) { 3300 }

      it 'returns a 404 error and does not create a bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      404,
                                      'id' => 27, '_headers' => headers,
                                      '_data' => body)
        end.to_not change { Bid.count }
      end
    end

    context 'when the auction has ended' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { create(:auction, :closed, :with_bidders) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a 403 error and does not create a bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      403,
                                      'id' => auction.id, '_headers' => headers,
                                      '_data' => body)
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the auction has not yet started' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { create(:auction, :future, :with_bidders) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a 403 error and does not create a bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      403,
                                      'id' => auction.id, '_headers' => headers,
                                      '_data' => body)
        end.to_not change { auction.bids.count }
      end
    end

    context 'when the user places a successful bid' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }
      let(:auction) { create(:auction, :running) }
      let(:current_auction_price) do
        auction.bids.sort_by(&:amount).first.amount
      end
      let(:bid_amount) { current_auction_price - 10 }

      it 'returns a 200 response and creates the bid' do
        expect do
          expect(subject).to validate(:post,
                                      '/auctions/{id}/bids',
                                      200,
                                      'id' => auction.id, '_headers' => headers,
                                      '_data' => body)
        end.to change { auction.bids.count }.by(1)
      end
    end
  end

  context 'GET /admin/auctions' do
    context 'when the API key is invalid' do
      it 'returns a HTTP 403 response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the API key is missing' do
      it 'returns a HTTP 403 response' do
        login
        api_key = nil

        expect(subject).to validate(:get,
                                    '/admin/auctions',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the user is not an admin' do
      it 'returns a HTTP 403 response' do
        login
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the user is an admin' do
      let(:user) { create(:admin_user) }

      it 'returns a 200 HTTP response' do
        login(user)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end

      it 'returns valid auctions' do
        login(user)
        create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions',
                                    200,
                                    "_headers" => headers(api_key))
      end
    end
  end

  context 'GET /admin/auctions/{id}' do
    context 'when the API key is invalid' do
      it 'returns a 403 HTTP response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY
        auction = create(:auction, :with_bidders)

        expect(subject).to validate(:get,
                                    '/admin/auctions/{id}',
                                    403,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end
    end

    context 'when the API key is missing' do
      it 'returns a 403 HTTP response' do
        login
        api_key = nil
        auction = create(:auction, :with_bidders)

        expect(subject).to validate(:get,
                                    '/admin/auctions/{id}',
                                    403,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end
    end

    context 'when the API key is valid' do
      it 'returns a 200 HTTP response' do
        user = create(:admin_user)
        login(user)
        auction = create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions/{id}',
                                    200,
                                    "id" => auction.id, "_headers" => headers(api_key))
      end
    end

    context 'when the auction is not found' do
      it 'returns a 404 HTTP response' do
        user = create(:admin_user)
        login(user)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/auctions/{id}',
                                    404,
                                    "id" => 87, "_headers" => headers(api_key))
      end
    end
  end

  context 'GET /admin/users' do
    context 'when the API key is invalid' do
      it 'returns a HTTP 403 response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/users',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the API key is missing' do
      it 'returns a HTTP 403 response' do
        login
        api_key = nil

        expect(subject).to validate(:get,
                                    '/admin/users',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the user is not an admin' do
      it 'returns a HTTP 403 response' do
        login
        api_key = FakeGitHub::INVALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/users',
                                    403,
                                    "_headers" => headers(api_key))
      end
    end

    context 'when the user is an admin' do
      let(:user) { create(:admin_user) }

      it 'returns a 200 HTTP response' do
        login(user)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/users',
                                    200,
                                    "_headers" => headers(api_key))
      end

      it 'returns information about all users' do
        # create a non-admin user too
        create(:user)

        login(user)
        create(:auction, :with_bidders)
        api_key = FakeGitHub::VALID_API_KEY

        expect(subject).to validate(:get,
                                    '/admin/users',
                                    200,
                                    "_headers" => headers(api_key))
      end
    end
  end
  
  context 'and' do
    it 'tests all documented routes' do
      expect(subject).to validate_all_paths
    end
  end
end
