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
    it 'should return a AdminAuctionStatusPresenter::Future' do
      auction = create(:auction, :future, :published)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::Future)
    end
  end

  context "when the vendor is late on delivery" do
    it 'should return a AdminAuctionStatusPresenter::OverdueDelivery' do
      auction = create(:auction, :closed, :published, :with_bids, delivery_status: :work_in_progress, delivery_due_at: 4.minutes.ago)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::OverdueDelivery)
    end
  end

  context "when the auction has been marked as a missed delivery" do
    it 'should return a AdminAuctionStatusPresenter::Future' do
      auction = create(:auction, :closed, :published, :with_bids, delivery_due_at: 4.minutes.ago, delivery_status: :missed_delivery)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::MissedDelivery)
    end
  end

  context "when an auction has been accepted but doesn't have a payment URL yet" do
    it 'should return a AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl' do
      auction = create(:auction, :closed, :with_bids, :published, :delivery_url, delivery_status: :accepted_pending_payment_url)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::AcceptedPendingPaymentUrl)
    end
  end

  context 'when the auction has been accepted' do
    it 'should return a AdminAuctionStatusPresenter::DefaultPcard::Accepted' do
      auction = create(:auction, :accepted)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::DefaultPcard::Accepted)
    end
  end

  context 'when an auction has been accepted but is for an other pcard' do
    it 'should return a AdminAuctionStatusPresenter::OtherPcard::Accepted' do
      auction = create(:auction, :payment_needed, purchase_card: :other)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::OtherPcard::Accepted)
    end
  end

  context 'when the auction has been rejected' do
    it 'should return a AdminAuctionStatusPresenter::Rejected' do
      auction = create(:auction, :rejected)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::Rejected)
    end

    context 'rejected auction has no winner' do
      it 'should return a AdminAuctionStatusPresenter::Rejected' do
        auction = create(:auction, :rejected)

        expect(
          AdminAuctionStatusPresenterFactory.new(auction: auction).create.body
        ).to eq(
          I18n.t(
            'statuses.admin_auction_status_presenter.rejected.body',
            delivery_url: auction.delivery_url,
            rejected_at: DcTimePresenter.convert_and_format(auction.rejected_at),
            winner_name: 'N/A'
          )
        )
      end
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

  context 'when auction is available' do
    it 'should return the correct presenter' do
      auction = create(:auction, :c2_budget_approved, :available)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::Available)
    end
  end

  context 'when auction is closed, pending delivery' do
    it 'should return the correct presenter' do
      auction = create(:auction, :c2_budget_approved, :closed, :with_bids, delivery_status: :pending_delivery)

      expect(AdminAuctionStatusPresenterFactory.new(auction: auction).create)
        .to be_a(AdminAuctionStatusPresenter::WorkNotStarted)
    end
  end
end
