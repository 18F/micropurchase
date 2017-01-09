class C2StatusPresenter::Sent < C2StatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.sent.header')
  end

  def body
    I18n.t('statuses.c2_presenter.sent.body')
  end

  def action_partial
    'admin/auctions/sent'
  end

  def self.relevant?(status)
    status.c2_sent?
  end
end
