require 'rails_helper'

describe C2StatusPresenter::PendingApproval do
  describe '#body' do
    it 'returns the body for pending_approval' do
      auction = create(:auction, :pending_c2_approval)
      presenter = C2StatusPresenter::PendingApproval.new(auction: auction)

      expect(presenter.body)
        .to eq(I18n.t('statuses.c2_presenter.pending_approval.body',
                      link: auction.c2_proposal_url))
    end
  end

  describe '#header' do
    it 'returns the header for pending_approval' do
      auction = create(:auction, :pending_c2_approval)
      presenter = C2StatusPresenter::PendingApproval.new(auction: auction)

      expect(presenter.header)
        .to eq(I18n.t('statuses.c2_presenter.pending_approval.header'))
    end
  end
end
