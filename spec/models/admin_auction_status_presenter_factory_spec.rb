require 'rails_helper'

describe AdminAuctionStatusPresenterFactory do
  context 'when the auction approval is not requested' do
    it 'should return a AdminAuctionStatusPresenter::NotRequested' do
      auction = create(:auction, c2_status: :not_requested)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::NotRequested)
    end
  end

  context 'when the auction approval request is sent' do
      it 'should return a AdminAuctionStatusPresenter::Sent' do
        auction = create(:auction, c2_status: :sent)

        expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
          .to be_a(C2StatusPresenter::Sent)
    end
  end

  context 'when the auction approval request is pending' do
    it 'should return a AdminAuctionStatusPresenter::PendingApproval' do
      auction = create(:auction, c2_status: :pending_approval)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::PendingApproval)
    end
  end

  context 'when auction is approved' do
    it 'should return a AdminAuctionStatusPresenter::Approved' do
      auction = create(:auction, c2_status: :approved)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::Approved)
    end
  end
end
