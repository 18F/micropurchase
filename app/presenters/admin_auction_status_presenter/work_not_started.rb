class AdminAuctionStatusPresenter::WorkNotStarted < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.work_not_started.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.work_not_started.body',
      winner_url: winner_url,
      delivery_deadline: delivery_deadline,
      winning_amount: winning_amount,
      ended_at: ended_at
    )
  end

  private

  def ended_at
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def delivery_deadline
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  def winning_amount
    Currency.new(winning_bid.amount)
  end
end
