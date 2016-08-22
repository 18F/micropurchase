class BidStatusPresenter::Over::Vendor::Winner::WorkNotStarted < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.ready_for_work.header')
  end

  def body
    I18n.t(
      'auctions.show.status.ready_for_work.body',
      ended_at: end_date,
      delivery_deadline: delivery_deadline,
      issue_url: auction.issue_url
    )
  end

  def action_partial
    'auctions/delivery_url'
  end
end
