class BidStatusPresenter::OverUserIsWinnerWorkInProgress < BidStatusPresenter::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def header
    I18n.t('auctions.show.status.work_in_progress.header')
  end

  def body
    I18n.t(
      'auctions.show.status.work_in_progress.body',
      ended_at: end_date,
      delivery_deadline: delivery_deadline,
      delivery_url: auction.delivery_url
    )
  end

  def action_partial
    'auctions/work_in_progress'
  end
end
