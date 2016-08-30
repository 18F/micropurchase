class BidStatusPresenter::Unpublished::Guest < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.unpublished.guest.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.unpublished.guest.body')
  end
end
