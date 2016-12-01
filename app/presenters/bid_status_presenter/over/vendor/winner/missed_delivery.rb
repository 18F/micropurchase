class BidStatusPresenter::Over::Vendor::Winner::MissedDelivery < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.work_not_delivered.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.work_not_delivered.body',
      delivery_deadline: delivery_deadline
    )
  end

  private

  def delivery_deadline
    DcTimePresenter.new(auction.delivery_due_at).convert_and_format
  end
end
