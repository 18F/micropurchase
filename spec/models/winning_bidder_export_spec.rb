require 'rails_helper'

describe WinningBidderExport do
  describe '#export_csv' do
    context 'DUNs number valid' do
      it 'include the correct information in the CSV' do
        end_date = DateTime.new(2016, 07, 11, 00, 00, 0)
        delivery_date = DateTime.new(2016, 07, 17, 00, 00, 0)
        auction = create(
          :auction,
          :closed,
          :with_bids,
          ended_at: end_date,
          delivery_due_at: delivery_date
        )
        winning_bid = WinningBid.new(auction).find
        winning_bid.bidder.update(duns_number: FakeSamApi::VALID_DUNS)

        export = WinningBidderExport.new(auction).export_csv

        parsed = CSV.parse(export)
        expect(parsed[1][0]).to include('Sudol, Brendan')
        expect(parsed[1][1]).to include('4301 N Henderson Rd Apt 408')
        expect(parsed[1][4]).to include('Arlington')
        expect(parsed[1][5]).to include('VA')
        expect(parsed[1][6]).to include('222032511')
        expect(parsed[1][7]).to include('USA')
        expect(parsed[1][8]).to include('5404218332')
        expect(parsed[1][10]).to include('20160711')
        expect(parsed[1][11]).to include('20160717')
        expect(parsed[1][12]).to include(winning_bid.amount.to_s)
        expect(parsed[1][13]).to include(winning_bid.amount.to_s)
        expect(parsed[1][14]).to include(winning_bid.amount.to_s)
        expect(parsed[1][15]).to include(auction.description)
        expect(parsed[1][16]).to include(WinningBidderExport::PURCHASE_CARD_AS_PAYMENT_METHOD)
        expect(parsed[1][17]).to include(WinningBidderExport::NATIONAL_INTEREST_ACTION)
        expect(parsed[1][18]).to include(FakeSamApi::VALID_DUNS)
        expect(parsed[1][19]).to include('Sudol, Brendan')
        expect(parsed[1][20]).to include(WinningBidderExport::COMMERCIAL_ITEM_TEST_PROGRAM)
        expect(parsed[1][21]).to include(WinningBidderExport::SOLICITATION_PROCEDURES)
      end
    end

    context 'DUNS number invalid' do
      it 'raises invalid duns error' do
        auction = create(:auction, :closed, :with_bids)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(duns_number: FakeSamApi::INVALID_DUNS)

        expect do
          WinningBidderExport.new(auction).export_csv
        end.to raise_error(WinningBidderExport::Error)
      end
    end
  end
end
