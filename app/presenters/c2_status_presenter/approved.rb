class C2StatusPresenter::Approved < C2StatusPresenter::Base
  def status
    I18n.t('statuses.c2_presenter.approved.status')
  end

  def header
    I18n.t('statuses.c2_presenter.approved.header')
  end

  def body
    I18n.t('statuses.c2_presenter.approved.body', link: link)
  end

  def link
    auction.c2_proposal_url
  end
end
