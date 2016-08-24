require 'rails_helper'

describe Api::V0::Admin::AuctionsController do
  include RequestHelpers

  describe 'GET /auctions' do
    it 'returns iso8601 dates' do
      login
      create(:auction)

      get api_v0_auctions_path(format: :json), nil, headers

      expect(json_auctions.map { |a| a['created_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['updated_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['started_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['ended_at'] }).to all(be_iso8601)
    end

    context 'when the auction is reverse' do
      context 'and the auction is available, has bidders' do
        it 'veils all bidder information' do
          login
          create(:auction, :available, :reverse, :with_bidders)

          get api_v0_auctions_path(format: :json), nil, headers

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

        context 'and the auction is closed' do
          it 'unveils all bidder information' do
            login
            create(:auction, :closed, :reverse, :with_bidders)

            get api_v0_auctions_path(format: :json), nil, headers

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

    context 'when the auction is sealed-bid' do
      context 'and the auction is available, has bidders' do
        it 'veils all bids' do
          login
          create(:auction, :available, :sealed_bid, :with_bidders)
          get '/api/v0/auctions', nil, headers
          expect(json_bids).to be_empty
        end

        context 'and the auction is closed' do
          it 'unveils all bids' do
            login
            auction = create(:auction, :closed, :sealed_bid, :with_bidders)

            get api_v0_auctions_path(format: :json), nil, headers

            json_bids.each do |bid|
              expect(bid['bidder_id']).to_not be_nil
              bidder = bid['bidder']
              expect(bidder['id']).to_not be_nil
              expect(bidder['name']).to_not be_nil
              expect(bidder['duns_number']).to_not be_nil
              expect(bidder['github_id']).to_not be_nil
              expect(bidder['created_at']).to_not be_nil
              expect(bidder['updated_at']).to_not be_nil
            end

            expect(json_bids.length).to eq(auction.bids.length)
          end
        end
      end
    end

    def json_bids
      json_auctions.first['bids']
    end

    def json_auctions
      json_response['auctions']
    end
  end
end
