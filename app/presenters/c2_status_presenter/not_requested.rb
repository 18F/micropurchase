class C2StatusPresenter::NotRequested < C2StatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.not_requested.header')
  end

  def body
    I18n.t('statuses.c2_presenter.not_requested.body')
  end

  def action_partial
    'admin/auctions/request_approval'
  end

  def self.relevant?(status)
    status.c2_not_requested?
  end
end
