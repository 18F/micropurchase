class BidStatusPresenter::OverUserIsWinnerPaymentConfirmed < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.payment_confirmed.header')
  end

  def body
    I18n.t(
      'auctions.show.status.payment_confirmed.body',
      end_date: end_date,
      accepted_date: accepted_date,
      amount: winning_amount,
      paid_at: paid_date
    )
  end

  private

  def accepted_date
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end

  def paid_date
    DcTimePresenter.convert_and_format(auction.paid_at)
  end
end
