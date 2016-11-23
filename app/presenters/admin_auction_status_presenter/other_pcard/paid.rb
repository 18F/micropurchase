class AdminAuctionStatusPresenter::OtherPcard::Paid < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.other_pcard.paid.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.other_pcard.paid.body',
      winner_url: winner_url,
      paid_at: paid_at,
      winning_amount: winning_amount
    )
  end

  def self.relevant?(status)
    status.accepted? && status.paid_at_info?
  end

  private

  def paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end

  def winning_amount
    Currency.new(winning_bid.amount).to_s
  end
end
