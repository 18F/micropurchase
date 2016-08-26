class C2StatusPresenter::PendingApproval < C2StatusPresenter::Base
  def status
    I18n.t('statuses.c2_presenter.pending_approval.status')
  end

  def header
    I18n.t('statuses.c2_presenter.pending_approval.header')
  end

  def body
    I18n.t('statuses.c2_presenter.pending_approval.body')
  end

  def action_partial
    'admin/auctions/pending'
  end
end
