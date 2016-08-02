class C2StatusPresenter::Pending < C2StatusPresenter::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def status
    I18n.t('statuses.c2_presenter.pending.status')
  end

  def header
    I18n.t('statuses.c2_presenter.pending.header')
  end

  def body
    I18n.t('statuses.c2_presenter.pending.body', link: link)
  end

  def link
    link_to(
      'here',
      auction.c2_proposal_url,
      target: '_blank'
    )
  end
end
