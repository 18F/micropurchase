class C2StatusPresenter::ApprovalNotRequested < C2StatusPresenter::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def status
    I18n.t('statuses.c2_presenter.approval_not_requested.status')
  end

  def header
    I18n.t('statuses.c2_presenter.approval_not_requested.header')
  end

  def body
    I18n.t('statuses.c2_presenter.approval_not_requested.body', link: link)
  end

  def link
    link_to(
      'Request approval',
      admin_proposals_path(auction_id: auction.id),
      method: :post,
      class: 'usa-button usa-button-outline auction-button'
    )
  end
end
