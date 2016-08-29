class BidStatusPresenter::Available::Guest < BidStatusPresenter::Base
  def body
    I18n.t(
      'statuses.bid_status_presenter.available.guest.body',
      end_date: end_date,
      sign_in_link: sign_in_link,
      sign_up_link: sign_up_link
    )
  end
end
