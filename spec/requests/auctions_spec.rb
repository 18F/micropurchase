require 'rails_helper'

RSpec.describe AuctionsController do
  before do
    stub_github('/user') do
      github_response_for_user(user)
    end
  end
  let!(:auctions) do
    10.times.to_a.map { FactoryGirl.create(:auction, :with_bidders) }
  end
  let(:user)          { FactoryGirl.create(:user, github_id: 86790) }
  let(:json_response) { JSON.parse(response.body) }
  let(:json_auctions) { json_response['auctions'] }
  let(:headers) do
    {
      'HTTP_ACCEPT' => 'text/x-json',
      'HTTP_API_KEY' => api_key
    }
  end

  describe 'GET /auctions/:id' do
    let(:auction)      { auctions.first }
    let(:json_auction) { json_response['auction'] }

    before do
      get auction_path(auction), nil, headers
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHub::INVALID_API_KEY }

      it 'ignores the key and returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end
    end

    context 'when the API key is missing' do
      let(:api_key) { nil }

      it 'returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end
    end

    context 'when the API key is valid' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }

      it 'returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end

      it 'returns a valid auction' do
        expect(response).to match_response_schema('auction')
      end

      it 'returns iso8601 dates' do
        expect(json_auction['created_at']).to be_iso8601
        expect(json_auction['updated_at']).to be_iso8601
        expect(json_auction['start_datetime']).to be_iso8601
        expect(json_auction['end_datetime']).to be_iso8601
      end

      context 'when the auction is single bid' do
        context 'and the auction is running' do
          let!(:auction)     { FactoryGirl.create(:auction, :running, :single_bid, :with_bidders) }
          let(:json_bids)    { json_auction['bids'] }

          it 'veils all bids' do
            expect(json_bids).to be_empty
          end

          context 'and the authenticated user is one of the bidders' do
            let(:api_key)  { FakeGitHub::VALID_API_KEY }
            let!(:auction) do
              FactoryGirl.create(:auction, :single_bid, :running, bidder_ids: [user.id])
            end

            let(:authenticated_users_bid) do
              json_response['auction']['bids'].find {|b| b['bidder_id'] == user.id}
            end
            let(:all_the_other_bids) do
              json_response['auction']['bids'].select {|b| b['bidder_id'] != user.id}
            end

            it 'does not veil the bids from the authenticated user' do
              expect(authenticated_users_bid['bidder_id']).to_not be_nil

              bidder = authenticated_users_bid['bidder']

              expect(bidder['id']).to_not          be_nil
              expect(bidder['name']).to_not        be_nil
              expect(bidder['duns_number']).to_not be_nil
              expect(bidder['github_id']).to_not   be_nil
              expect(bidder['created_at']).to_not  be_nil
              expect(bidder['updated_at']).to_not  be_nil
              expect(bidder['sam_status']).to_not be_nil
            end

            it 'veils the bids not created by the authenticated user' do
              expect(json_bids).to include(authenticated_users_bid)
              expect(json_bids.length).to eq(1)
            end
          end
        end

        context 'and the auction is closed' do
          let!(:auction)  { FactoryGirl.create(:auction, :closed, :single_bid, :with_bidders) }
          let(:json_bids) { json_auction['bids'] }

          it 'unveils all bids information' do
            json_bids.each do |bid|
              expect(bid['bidder_id']).to_not be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to_not          be_nil
              expect(bidder['name']).to_not        be_nil
              expect(bidder['duns_number']).to_not be_nil
              expect(bidder['github_id']).to_not   be_nil
              expect(bidder['created_at']).to_not  be_nil
              expect(bidder['updated_at']).to_not  be_nil
              expect(bidder['sam_status']).to_not be_nil
            end
          end
        end
      end

      context 'when the auction is mult-bid' do
        context 'and the auction is running' do
          let!(:auction)     { FactoryGirl.create(:auction, :running, :with_bidders) }
          let(:json_bids)    { json_auction['bids'] }

          it 'veils all bidder information' do
            json_bids.each do |bid|
              expect(bid['bidder_id']).to be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to          be_nil
              expect(bidder['name']).to        be_nil
              expect(bidder['duns_number']).to be_nil
              expect(bidder['github_id']).to   be_nil
              expect(bidder['created_at']).to  be_nil
              expect(bidder['updated_at']).to  be_nil
              expect(bidder['sam_status']).to be_nil
            end
          end

          context 'and the authenticated user is one of the bidders' do
            let(:api_key)  { FakeGitHub::VALID_API_KEY }
            let!(:auction) do
              FactoryGirl.create(:auction, :running, bidder_ids: [user.id])
            end

            let(:authenticated_users_bid) do
              json_response['auction']['bids'].find {|b| b['bidder_id'] == user.id}
            end
            let(:all_the_other_bids) do
              json_response['auction']['bids'].select {|b| b['bidder_id'] != user.id}
            end

            it 'does not veil the bids from the authenticated user' do
              expect(authenticated_users_bid['bidder_id']).to_not be_nil

              bidder = authenticated_users_bid['bidder']

              expect(bidder['id']).to_not          be_nil
              expect(bidder['name']).to_not        be_nil
              expect(bidder['duns_number']).to_not be_nil
              expect(bidder['github_id']).to_not   be_nil
              expect(bidder['created_at']).to_not  be_nil
              expect(bidder['updated_at']).to_not  be_nil
              expect(bidder['sam_status']).to_not be_nil
            end

            it 'veils the bids not created by the authenticated user' do
              all_the_other_bids.each do |bid|
                expect(bid['bidder_id']).to be_nil

                bidder = bid['bidder']

                expect(bidder['id']).to          be_nil
                expect(bidder['name']).to        be_nil
                expect(bidder['duns_number']).to be_nil
                expect(bidder['github_id']).to   be_nil
                expect(bidder['created_at']).to  be_nil
                expect(bidder['updated_at']).to  be_nil
                expect(bidder['sam_status']).to be_nil
              end
            end
          end
        end

        context 'and the auction is closed' do
          let!(:auctions) do
            [FactoryGirl.create(:auction, :closed, :with_bidders)]
          end
          let(:json_bids) { json_auction['bids'] }

          it 'unveils all bidder information' do
            json_bids.each do |bid|
              expect(bid['bidder_id']).to_not be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to_not          be_nil
              expect(bidder['name']).to_not        be_nil
              expect(bidder['duns_number']).to_not be_nil
              expect(bidder['github_id']).to_not   be_nil
              expect(bidder['created_at']).to_not  be_nil
              expect(bidder['updated_at']).to_not  be_nil
              expect(bidder['sam_status']).to_not be_nil
            end
          end
        end
      end
    end
  end

  describe 'GET /auctions' do
    before do
      get auctions_path, nil, headers
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHub::INVALID_API_KEY }

      it 'ignores the key and returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end
    end

    context 'when the API key is missing' do
      let(:api_key) { nil }

      it 'returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end
    end

    context 'when the API key is valid' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }

      it 'returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end

      it 'returns valid auctions' do
        expect(response).to match_response_schema('auctions')
      end

      it 'returns iso8601 dates' do
        expect(json_auctions.map {|a| a['created_at'] }).to all(be_iso8601)
        expect(json_auctions.map {|a| a['updated_at'] }).to all(be_iso8601)
        expect(json_auctions.map {|a| a['start_datetime'] }).to all(be_iso8601)
        expect(json_auctions.map {|a| a['end_datetime'] }).to all(be_iso8601)
      end

      context 'when the auction is multi bid' do
        context 'and the auction is running' do
          let!(:auctions) do
            [FactoryGirl.create(:auction, :running, :multi_bid, :with_bidders)]
          end
          let(:json_bids) { json_auctions.first['bids'] }

          it 'veils all bidder information' do
            json_bids.each do |bid|
              expect(bid['bidder_id']).to be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to          be_nil
              expect(bidder['name']).to        be_nil
              expect(bidder['duns_number']).to be_nil
              expect(bidder['github_id']).to   be_nil
              expect(bidder['created_at']).to  be_nil
              expect(bidder['updated_at']).to  be_nil
              expect(bidder['sam_status']).to be_nil
            end
          end

          context 'and the auction is closed' do
            let!(:auctions) do
              [FactoryGirl.create(:auction, :closed, :multi_bid, :with_bidders)]
            end
            let(:json_bids) { json_auctions.first['bids'] }

            it 'unveils all bidder information' do
              json_bids.each do |bid|
                expect(bid['bidder_id']).to_not be_nil
                bidder = bid['bidder']
                expect(bidder['id']).to_not          be_nil
                expect(bidder['name']).to_not        be_nil
                expect(bidder['duns_number']).to_not be_nil
                expect(bidder['github_id']).to_not   be_nil
                expect(bidder['created_at']).to_not  be_nil
                expect(bidder['updated_at']).to_not  be_nil
                expect(bidder['sam_status']).to_not be_nil
              end
            end
          end
        end
      end

      context 'when the auction is single bid' do
        context 'and the auction is running' do
          let!(:auctions) do
            [FactoryGirl.create(:auction, :running, :single_bid, :with_bidders)]
          end
          let(:json_bids) { json_auctions.first['bids'] }

          it 'veils all bids' do
            expect(json_bids).to be_empty
          end

          context 'and the auction is closed' do
            let!(:auctions) do
              [FactoryGirl.create(:auction, :closed, :single_bid, :with_bidders)]
            end
            let(:json_bids) { json_auctions.first['bids'] }

            it 'unveils all bids' do
              json_bids.each do |bid|
                expect(bid['bidder_id']).to_not be_nil
                bidder = bid['bidder']
                expect(bidder['id']).to_not          be_nil
                expect(bidder['name']).to_not        be_nil
                expect(bidder['duns_number']).to_not be_nil
                expect(bidder['github_id']).to_not   be_nil
                expect(bidder['created_at']).to_not  be_nil
                expect(bidder['updated_at']).to_not  be_nil
              end

              expect(json_bids.length).to eq(auctions.first.bids.length)
            end
          end
        end
      end
    end
  end
end
