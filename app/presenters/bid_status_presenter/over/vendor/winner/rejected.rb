class BidStatusPresenter::Over::Vendor::Winner::Rejected < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.rejected.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.rejected.body',
      rejected_at: DcTimePresenter.convert_and_format(auction.rejected_at)
    )
  end
end
