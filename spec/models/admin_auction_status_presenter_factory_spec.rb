require 'rails_helper'

describe AdminAuctionStatusPresenterFactory do
  context 'when the auction approval is not requested' do
    it 'should return a C2StatusPresenter::NotRequested' do
      auction = create(:auction, c2_status: :not_requested)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::NotRequested)
    end
  end

  context "when the auction has been published but hasn't started yet" do
    it 'should return a AdminAuctionStatusPresenter::FuturePublished' do
      auction = create(:auction, :future, :published)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::FuturePublished)
    end
  end

  context 'when the auction has been approved' do
    it 'should return a AdminAuctionStatusPresenter::Accepted' do
      auction = create(:auction, :closed, :with_bids, :delivery_url, :accepted)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::Accepted)
    end
  end

  context 'when the auction has been rejected' do
    it 'should return a AdminAuctionStatusPresenter::Rejected' do
      auction = create(:auction, :closed, :with_bids, :delivery_url, :rejected)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::Rejected)
    end
  end

  context 'when the auction approval request is sent' do
    it 'should return a C2StatusPresenter::Sent' do
      auction = create(:auction, c2_status: :sent)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::Sent)
    end
  end

  context 'when the auction approval request is pending' do
    it 'should return a C2StatusPresenter::PendingApproval' do
      auction = create(:auction, c2_status: :pending_approval)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::PendingApproval)
    end
  end

  context 'when auction is approved' do
    it 'should return a C2StatusPresenter::Approved' do
      auction = create(:auction, c2_status: :approved)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::Approved)
    end
  end
end
