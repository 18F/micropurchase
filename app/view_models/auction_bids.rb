class AuctionBids
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def bids_count
    auction.bids.count
  end

  def sealed_bids_partial
    if available? && auction.type == 'single_bid'
      'bids/sealed'
    else
      'components/null'
    end
  end

  def veiled_bids
    if available? && auction.type == 'single_bid'
      auction.bids.where(bidder: current_user).map do |bid|
        BidListItem.new(bid: bid, user: current_user)
      end
    else
      auction.bids.order(created_at: :desc).map do |bid|
        BidListItem.new(bid: bid, user: current_user)
      end
    end
  end

  def tag_data_value_status
    status_presenter.tag_data_value_status
  end

  def tag_data_label_2
    status_presenter.tag_data_label_2
  end

  def tag_data_value_2
    status_presenter.tag_data_value_2
  end

  private

  def status_presenter
    @status_presenter ||= status_presenter_class.new(auction)
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
    "::AuctionStatus::#{status_name}ViewModel".constantize
  end

  def available?
    auction_status.available?
  end

  def expiring?
    auction_status.expiring?
  end

  def future?
    auction_status.future?
  end

  def over?
    auction_status.over?
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end
