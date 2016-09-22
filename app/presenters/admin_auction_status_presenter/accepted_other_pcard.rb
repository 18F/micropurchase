class AdminAuctionStatusPresenter::AcceptedOtherPcard < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.accepted_other_pcard.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.accepted_other_pcard.body',
      customer_url: customer_url,
      accepted_at: accepted_at,
      winner_url: winner_url
    )
  end

  def action_partial
    'admin/auctions/mark_paid'
  end

  private

  def accepted_at
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end

  def customer_url
    Url.new(
      link_text: customer_name,
      path_name: 'admin_customer',
      params: { id: customer.id }
    )
  end

  def customer
    auction.customer
  end

  def customer_name
    customer.agency_name
  end
end
