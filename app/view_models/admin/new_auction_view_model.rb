class Admin::NewAuctionViewModel < Admin::BaseViewModel
  attr_reader :auction
  DEFAULT_START_DAYS = 5
  DEFAULT_END_DAYS = 7
  DEFAULT_DELIVERY_DAYS = 12

  def initialize(auction = nil)
    @auction = auction
  end

  def new_record
    auction || Auction.new
  end

  def new_auction_nav_class
    'usa-current'
  end

  def delivery_due_partial
    'admin/auctions/due_in_days'
  end

  def estimated_delivery_due_at
    DcTimePresenter.convert_and_format(default_date_time('delivery_due_at').convert)
  end

  def date_default(field)
    default_date_time(field).convert.to_date
  end

  def hour_default(field)
    default_date_time(field).hour
  end

  def minute_default(field)
    default_date_time(field).minute
  end

  def meridiem_default(field)
    default_date_time(field).meridiem
  end

  def billable_to_options
    ClientAccount.all.map(&:to_s)
  end

  def published
    'unpublished'
  end

  def published_options
    ['unpublished']
  end

  def customer_options
    Customer.sorted
  end

  private

  def default_date_time(field)
    if field == 'started'
      DefaultDateTime.new(DEFAULT_START_DAYS.business_days.from_now)
    elsif field == 'ended'
      DefaultDateTime.new(DEFAULT_END_DAYS.business_days.from_now)
    else
      DefaultDateTime.new(DEFAULT_DELIVERY_DAYS.business_days.from_now)
    end
  end
end
