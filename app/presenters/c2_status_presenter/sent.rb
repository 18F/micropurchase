class C2StatusPresenter::Sent < C2StatusPresenter::Base
  def status
    I18n.t('statuses.c2_presenter.sent.status')
  end

  def header
    I18n.t('statuses.c2_presenter.sent.header')
  end

  def body
    I18n.t('statuses.c2_presenter.sent.body')
  end
end
