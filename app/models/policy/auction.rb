class Policy::Auction
  BID_LIMIT = 3500
  BID_INCREMENT = 1

  include ActionView::Helpers::NumberHelper

  attr_reader :auction, :user

  # I don't want to make a Factory class yet
  def self.factory(auction, user)
    case auction.type
    when Policy::MultiBidAuction::TYPE_CODE
      Policy::MultiBidAuction.new(auction, user)
    when Policy::SingleBidAuction::TYPE_CODE
      Policy::SingleBidAuction.new(auction, user)
    else
      fail "Unsupported auction type: #{auction.type}"
    end
  end

  def veiled_bids?
    available?
  end

  def highlighted_bid
    winning_bid
  end

  def winning_bid?
    case winning_bid
    when nil, Presenter::Bid::Null
      false
    else
      true
    end
  end
  
  def winning_bid
    lowest_bid
  end

  def winning_bidder_name
    winning_bid.name
  end

  def winning_bid_amount
    lowest_bid_amount
  end

  def highlighted_bid?
    case highlighted_bid
    when nil, Presenter::Bid::Null
      false
    else
      true
    end
  end
  
  def available?
    return false if start_datetime.nil? || end_datetime.nil?
    !future? && !over?
  end

  def over?
    end_datetime < Time.now
  end

  def future?
    start_datetime > Time.now
  end

  def expiring?
    available? && end_datetime < 12.hours.from_now
  end

  def user_logged_in?
    !user.nil?
  end

  def user_id
    user.id
  end
  
  def user_is_bidder?
    return false if user.nil?
    bids.detect {|b| user.id == b.bidder_id } != nil
  end

  def user_is_winning_bidder?
    return false unless user && winning_bid?
    user.id == winning_bid.bidder_id
  end

  def user_bids
    return [] if user.nil?
    bids.select {|b| user.id == b.bidder_id }.map {|x| Presenter::Bid.new(x) }
  end
  
  def user_can_bid?
    return false unless available?
    return false if !user_logged_in? || !user.sam_account?
    true
  end

  def show_bid_button?
    !user_logged_in? || user_can_bid?
  end

  def validate_bid(amount)
    validate_auction
    validate_user
    validate_amount(amount)
  end
  
  def status
    if available?
      'Open'
    else
      'Closed'
    end
  end

  def open_bid_status_label
    'Current bid:'
  end

  def status_partial
    'auctions/auction_status'
  end

  def status_presenter_class
    status_name = if expiring?
                    'Expiring'
                  elsif over?
                    'Over'
                  elsif future?
                    'Future'
                  else
                    'Open'
                  end
    "::Presenter::AuctionStatus::#{status_name}".constantize
  end

  def status_presenter
    @status_presenter ||= status_presenter_class.new(self)
  end

  def user_bid_amount_as_currency(user)
    number_to_currency(lowest_user_bid_amount)
  end
  

  # def current_bid_record
  #   @current_bid_record ||= bids.sort_by {|bid| [bid.amount, bid.created_at, bid.id] }.first
  # end

  delegate :label_class, :label, :tag_data_value_status, :tag_data_label_2, :tag_data_value_2,
           to: :status_presenter

  delegate :start_datetime, :end_datetime, :bids, :bids?, :bid_count, :start_price, :id,
           :title, :html_summary, :human_start_time, :html_description, :issue_url, :starts_at, :ends_at,
           :type,
           to: :auction

  delegate :bidder_name, :bidder_duns_number, :amount, :time, to: :highlighted_bid, prefix: true

  def to_param
    auction.to_param
  end

  def lowest_user_bid
    user_bids.sort_by(&:amount).first || Presenter::Bid::Null.new
  end

  def lowest_user_bid_amount
    lowest_user_bid.raw_amount
  end

  protected

  def initialize(auction, user)
    @auction = presenter_auction(auction)
    @user = presenter_user(user)
  end

  def presenter_auction(auction)
    case auction
    when Presenter::Auction
      auction
    when ::Auction
      Presenter::Auction.new(auction)
    when nil
      nil
    else
      fail "Unknown type '#{auction.klass}' for auction"
    end
  end

  def presenter_user(user)
    case user
    when Presenter::User
      user
    when ::User
      Presenter::User.new(user)
    when nil
      nil
    else
      fail "Unknown type '#{userklass}' for user"
    end
  end
  
  def lowest_bids
    @lowest_bids ||= bids.select {|b| lowest_bid_amount == b.amount }.sort_by(&:created_at)
  end

  def lowest_bid
    return Presenter::Bid::Null.new if lowest_bids.empty?
    lowest_bids.first
  end

  def lowest_bid_amount
    return nil unless bids?
    bids.sort_by(&:amount).first.amount
  end

  def validate_auction
    unless available?
      fail UnauthorizedError, 'Auction not available'
    end
  end
  
  def validate_user
    unless user_logged_in?
      fail UnauthorizedError, 'You must be logged in to bid on an auction'
    end

    unless user_can_bid?
      fail UnauthorizedError, 'You are not allowed to place a bid in this auction.'
    end
  end

  def validate_amount(amount)
    if amount.to_i != amount
      fail UnauthorizedError, 'Bids must be in increments of one dollar'
    end

    if amount > BID_LIMIT
      fail UnauthorizedError, 'Bid too high'
    end

    if amount <= 0
      fail UnauthorizedError, 'Bid amount out of range'
    end
  end
end
