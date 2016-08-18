class C2StatusPresenter::NotRequested < C2StatusPresenter::Base
  def status
    I18n.t('statuses.c2_presenter.approval_not_requested.status')
  end

  def header
    I18n.t('statuses.c2_presenter.approval_not_requested.header')
  end

  def body
    I18n.t('statuses.c2_presenter.approval_not_requested.body')
  end

  def action_partial
    'admin/auctions/request_approval'
  end
end
