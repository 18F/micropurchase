require 'rails_helper'

describe WinningBidderExport do
  describe '#export_csv' do
    context 'DUNs number valid' do
      it 'include the correct information in the CSV' do
        auction = create(:auction, :closed, :with_bidders)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(duns_number: FakeSamApi::VALID_DUNS)

        export = WinningBidderExport.new(auction).export_csv

        parsed = CSV.parse(export)
        expect(parsed[1][0]).to include('Sudol, Brendan')
        expect(parsed[1][1]).to include('4301 N Henderson Rd Apt 408')
        expect(parsed[1][4]).to include('Arlington')
        expect(parsed[1][5]).to include('VA')
        expect(parsed[1][6]).to include('222032511')
        expect(parsed[1][7]).to include('USA')
        expect(parsed[1][8]).to include('5404218332')
      end
    end

    context 'DUNS number invalid' do
      it 'raises invalid duns error' do
        auction = create(:auction, :closed, :with_bidders)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(duns_number: FakeSamApi::INVALID_DUNS)

        expect {
          WinningBidderExport.new(auction).export_csv
        }.to raise_error(WinningBidderExport::Error)
      end
    end
  end
end
