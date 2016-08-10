class BidStatusPresenter::OverUserIsWinnerPendingAcceptance < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def header
    I18n.t('auctions.show.status.pending_acceptance.header')
  end

  def body
    I18n.t(
      'auctions.show.status.pending_acceptance.body',
      delivery_url: auction.delivery_url
    )
  end
end
