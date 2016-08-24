class AdminAuctionStatusPresenter::Rejected
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def header
    I18n.t('statuses.c2_presenter.rejected.header')
  end

  def body
    I18n.t(
      'statuses.c2_presenter.rejected.body',
      delivery_url: auction.delivery_url,
      rejected_at: rejected_at,
      winner_email: winner.email
    )
  end

  def action_partial
    'components/null'
  end

  private

  def winner
    WinningBid.new(auction).find.bidder
  end

  def rejected_at
    DcTimePresenter.convert_and_format(auction.rejected_at)
  end
end
