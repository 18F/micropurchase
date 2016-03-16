class Policy::Auction
  attr_reader :auction, :user

  # I don't want to make a Factory class yet
  def self.build(auction, user)
    auction = Presenter::Auction.new(auction) unless auction.is_a?(Presenter::Auction)
    user = Presenter::User.new(user) unless user.is_a?(Presenter::User)
    
    case auction.type
    when Policy::MultiBidAuction::TYPE_CODE
      Policy::MultiBidAuction.new(auction, user)
    when Policy::SingleBidAuction::TYPE_CODE
      Policy::SingleBidAuction.new(auction, user)
    else
      fail "Unsupported auction type: #{auction.type}"
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

  def user_is_bidder?
    return false if user.nil?
    bids.detect {|b| user.id == b.bidder_id } != nil
  end

  def user_bids
    return [] if user.nil?
    bids.select {|b| user.id == b.bidder_id }
  end

  def user_can_bid?
    return false unless available?
    return false if user && !user.sam_account?
    true
  end

  # def status
  #   if available?
  #     'Open'
  #   else
  #     'Closed'
  #   end
  # end

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

  def current_bid_record
    @current_bid_record ||= bids.sort_by {|bid| [bid.amount, bid.created_at, bid.id] }.first
  end

  delegate :label_class, :label, :tag_data_value_status, :tag_data_label_2, :tag_data_value_2,
           to: :status_presenter

  delegate :start_datetime, :end_datetime, :bids?, :bids, :bid_count, :start_price,
           to: :auction

  protected

  def initialize(auction, user)
    @auction = auction
    @user = user
  end
  
  def lowest_bid_amount
    @lowest_bid_amount ||= bids.min {|a,b| a.amount <=> b.amount}.amount
  end

  def lowest_bids
    @lowest_bids ||= bids.select {|b| b.amount == lowest_bid_amount }.sort_by(&:created_at) 
  end
  
  def lowest_user_bid
    user_bids.sort_by(&:amount).first
  end

  def lowest_user_bid_amount
    bid = lowest_user_bid
    bid.nil? ? nil : bid.amount
  end
end
