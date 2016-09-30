require 'rails_helper'

describe C2StatusPresenter::BudgetApproved do
  describe '#status' do
    it 'returns the status for budget_approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::BudgetApproved.new(auction: auction)

      expect(presenter.status)
        .to eq(I18n.t('statuses.c2_presenter.budget_approved.status'))
    end
  end

  describe '#body' do
    it 'returns the body for budget_approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::BudgetApproved.new(auction: auction)

      expect(presenter.body).to eq(
        I18n.t('statuses.c2_presenter.budget_approved.body', link: presenter.link)
      )
    end
  end

  describe '#header' do
    it 'returns the header for budget_approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::BudgetApproved.new(auction: auction)

      expect(presenter.header).to eq(
        I18n.t('statuses.c2_presenter.budget_approved.header')
      )
    end
  end
end
