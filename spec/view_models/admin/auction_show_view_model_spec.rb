require 'rails_helper'

describe Admin::AuctionShowViewModel do
  describe '#admin_data' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal URL and c2 status and receipt fields' do
        auction = create(:auction, purchase_card: :default)
        user = create(:user)

        view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
        data = view_model.admin_data

        expect(data).to have_key('C2 proposal URL')
        expect(data).to have_key('C2 approval status')
        expect(data).to have_key('Receipt URL')
      end
    end

    context 'auction for other purchase card' do
      it 'does not return c2 proposal URL or c2 status or receipt URL fields' do
        auction = create(:auction, purchase_card: :other)
        user = create(:user)

        view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)
        data = view_model.admin_data

        expect(data).not_to have_key('C2 proposal URL')
        expect(data).not_to have_key('C2 approval status')
        expect(data).not_to have_key('Receipt URL')
      end
    end
  end

  describe "#csv_report_partial" do
    it 'should return a partial when the auction is over and has a winner' do
      auction = create(:auction, :with_bids, :closed)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.csv_report_partial).to_not eq('components/null')
    end

    it 'should return a null partial when the auction had no winners' do
      auction = create(:auction, :closed)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.csv_report_partial).to eq('components/null')
    end

    it 'should be a null partial when the auction has not started' do
      auction = create(:auction, :future)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.csv_report_partial).to eq('components/null')
    end

    it 'should be a null partial when the auction is still running' do
      auction = create(:auction, :with_bids)
      user = create(:user)
      view_model = Admin::AuctionShowViewModel.new(auction: auction, current_user: user)

      expect(view_model.csv_report_partial).to eq('components/null')
    end
  end
end
