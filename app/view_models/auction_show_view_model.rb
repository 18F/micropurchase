class AuctionShowViewModel < Struct.new(:current_user, :auction_record)
  include ActionView::Helpers::NumberHelper

  def auction
    @auction ||= AuctionViewModel.new(current_user, auction_record)
  end

  delegate(
    :bid_count,
    :formatted_delivery_due_at,
    :formatted_end_time,
    :formatted_start_time,
    :html_description,
    :id,
    :issue_url,
    :show_bid_button?,
    :status_text,
    :summary,
    :title,
    :user_bid_amount_as_currency,
    to: :auction,
    prefix: true
  )

  delegate(
    :auction_rules_href,
    :auction_status,
    :auction_type,
    :highlighted_bid,
    :highlighted_bid_amount,
    :highlighted_bid_amount_as_currency,
    to: :auction
  )

  def auction_status_header
    if auction_won?
      "Winning bid (#{auction.highlighted_bidder_name}):"
    else
      auction.highlighted_bid_label
    end
  end

  def auction_status_partial
    # This is a bit ugly since the partial has an if-else in it now
    auction.partial_path('auction_status')
  end

  def current_user_header_partial
    win_header_partial
  end

  def win_header_partial
    auction.partial_path('win_header')
  end

  def auction_link_text
    "#{auction.bid_count} #{bid_to_plural}"
  end

  def auction_deadline_label
    if AuctionStatus.new(auction).over?
      "Auction ended at:"
    else
      "Bid deadline:"
    end
  end

  def auction_start_label
    if AuctionStatus.new(auction_record).over?
      "Auction started at:"
    else
      "Bid start time:"
    end
  end

  def auction_rules_link
    "<a href='#{auction_rules_href}'>Rules for #{auction.formatted_type} auctions</a>".html_safe
  end

  def auction_won?
    AuctionStatus.new(auction_record).over? && auction.bids?
  end

  def auction_has_delivery_due_at?
    !auction.delivery_due_at.blank?
  end

  private

  def bid_to_plural
    auction.bids? ? "bids" : "bid"
  end
end
