class C2StatusPresenter::Sent < C2StatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.sent.header')
  end

  def body
    I18n.t('statuses.c2_presenter.sent.body')
  end
end
