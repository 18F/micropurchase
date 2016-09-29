class Admin::EditAuctionViewModel < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def record
    auction
  end

  def delivery_due_partial
    'admin/auctions/delivery_due_at'
  end

  def date_default(field)
    dc_time(field).to_date
  end

  def hour_default(field)
    dc_time(field).strftime('%l').strip
  end

  def minute_default(field)
    dc_time(field).strftime('%M').strip
  end

  def meridiem_default(field)
    dc_time(field).strftime('%p').strip
  end

  def billable_to_options
    ([auction.billable_to] + ClientAccountQuery.new.active.map(&:to_s)).uniq
  end

  def customer_options
    ([auction.customer] + Customer.sorted).uniq.compact
  end

  def c2_proposal_partial
    if auction.purchase_card == "default"
      'admin/auctions/c2_proposal_url'
    else
      'components/null'
    end
  end

  def paid_at_partial
    if auction.purchase_card == "default" || auction.delivery_status != "accepted"
      'components/null'
    elsif auction.paid_at.present?
      'admin/auctions/disabled_paid_at'
    else
      'admin/auctions/paid_at'
    end
  end

  def delivery_url_partial
    'admin/auctions/delivery_url'
  end

  private

  def dc_time(field)
    DcTimePresenter.convert(field_value(field))
  end

  def field_value(field)
    auction.send("#{field}_at") || default_date_time
  end

  def default_date_time
    @_default_date_time ||= DefaultDateTime.new.convert
  end

  def closed?
    BiddingStatus.new(auction).over?
  end
end
