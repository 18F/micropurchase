require 'rails_helper'

describe C2StatusPresenterFactory do
  context 'when the auction approval is not requested' do
    it 'should return a C2StatusPresenter::ApprovalNotRequested' do
      auction = create(:auction, c2_approval_status: :not_requested)

      expect(C2StatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::ApprovalNotRequested)
    end
  end

  context 'when the auction approval request is sent' do
      it 'should return a C2StatusPresenter::Sent' do
        auction = create(:auction, c2_approval_status: :sent)

        expect(C2StatusPresenterFactory.new(auction: auction).create)
          .to be_a(C2StatusPresenter::Sent)
    end
  end

  context 'when the auction approval request is pending' do
    it 'should return a C2StatusPresenter::Pending' do
      auction = create(:auction, c2_approval_status: :pending)

      expect(C2StatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::Pending)
    end
  end

  context 'when auction is approved' do
    it 'should return a C2StatusPresenter::Approved' do
      auction = create(:auction, c2_approval_status: :approved)

      expect(C2StatusPresenterFactory.new(auction: auction).create)
        .to be_a(C2StatusPresenter::Approved)
    end
  end
end
