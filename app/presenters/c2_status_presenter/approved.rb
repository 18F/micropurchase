class C2StatusPresenter::Approved
  def initialize(auction:)
    @auction = auction
  end

  def status
    I18n.t('statuses.c2_presenter.approved.status')
  end

  def header
    I18n.t('statuses.c2_presenter.approved.header')
  end

  def body
    I18n.t('statuses.c2_presenter.approved.body', link: link)
  end

  attr_reader :auction

  def link
    auction.c2_proposal_url
  end
end
