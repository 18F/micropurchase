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
    ([auction.billable_to] + ClientAccount.all.map(&:to_s)).uniq
  end

  def published
    auction.published
  end

  def published_options
    if closed? || auction.c2_approved_at.present?
      Auction.publisheds.keys.to_a
    else
      ['unpublished']
    end
  end

  def customer_options
    ([auction.customer] + Customer.sorted).uniq.compact
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
    AuctionStatus.new(auction).over?
  end
end
