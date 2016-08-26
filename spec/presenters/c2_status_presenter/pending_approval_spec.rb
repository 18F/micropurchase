require 'rails_helper'

describe C2StatusPresenter::PendingApproval do
  describe '#status' do
    it 'returns the status for pending_approval' do
      auction = create(:auction)
      presenter = C2StatusPresenter::PendingApproval.new(auction: auction)

      expect(presenter.status)
        .to eq(I18n.t('statuses.c2_presenter.pending_approval.status'))
    end
  end

  describe '#body' do
    it 'returns the body for pending_approval' do
      auction = create(:auction)
      presenter = C2StatusPresenter::PendingApproval.new(auction: auction)

      expect(presenter.body)
        .to eq(I18n.t('statuses.c2_presenter.pending_approval.body'))
    end
  end

  describe '#header' do
    it 'returns the header for pending_approval' do
      auction = create(:auction)
      presenter = C2StatusPresenter::PendingApproval.new(auction: auction)

      expect(presenter.header)
        .to eq(I18n.t('statuses.c2_presenter.pending_approval.header'))
    end
  end
end
