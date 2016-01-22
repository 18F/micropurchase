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
        expect(json_auctions.map {|a| a['created_at']}).to all(be_iso8601)
        expect(json_auctions.map {|a| a['updated_at']}).to all(be_iso8601)
        expect(json_auctions.map {|a| a['start_datetime']}).to all(be_iso8601)
        expect(json_auctions.map {|a| a['end_datetime']}).to all(be_iso8601)
      end

      context 'and the auction is running' do
        let!(:auctions) do
          [FactoryGirl.create(:auction, :running)]
        end
        let(:json_bids) { json_auctions.first['bids'] }

        it 'veils all bidder information' do
          json_bids.each do |bid|
            expect(bid['bidder_id']).to eq(nil)
            bidder = bid['bidder']
            expect(bidder['id']).to          eq(nil)
            expect(bidder['github_id']).to   eq(nil)
            expect(bidder['created_at']).to  eq(nil)
            expect(bidder['updated_at']).to  eq(nil)
            expect(bidder['email']).to       eq(nil)
            expect(bidder['sam_account']).to eq(nil)
          end
        end

        context 'and the auction is closed' do
          let!(:auctions) do
            [FactoryGirl.create(:auction, :closed)]
          end
          let(:json_bids) { json_auctions.first['bids'] }

          it 'unveils all bidder information' do
            json_bids.each do |bid|
              expect(bid['bidder_id']).to_not eq(nil)
              bidder = bid['bidder']
              expect(bidder['id']).to_not          eq(nil)
              expect(bidder['github_id']).to_not   eq(nil)
              expect(bidder['created_at']).to_not  eq(nil)
              expect(bidder['updated_at']).to_not  eq(nil)
              expect(bidder['email']).to_not       eq(nil)
              expect(bidder['sam_account']).to_not eq(nil)
            end
          end
        end
      end
    end
  end
end
