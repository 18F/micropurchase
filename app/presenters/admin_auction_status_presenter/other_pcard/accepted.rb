class AdminAuctionStatusPresenter::OtherPcard::Accepted < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.other_pcard.accepted.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.other_pcard.accepted.body',
      customer_url: customer_url,
      accepted_at: accepted_at,
      winner_url: winner_url
    )
  end

  def action_partial
    'admin/auctions/mark_paid'
  end

  def self.relevant?(status)
    status.accepted? && !status.paid_at_info?
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
