class C2StatusPresenter::BudgetApproved < C2StatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.budget_approved.header')
  end

  def body
    I18n.t('statuses.c2_presenter.budget_approved.body', link: link)
  end

  def link
    auction.c2_proposal_url
  end
end
