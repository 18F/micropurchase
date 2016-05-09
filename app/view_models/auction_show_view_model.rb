class AuctionShowViewModel
  include ActionView::Helpers::NumberHelper

  attr_reader :auction

  def initialize(user: nil, auction:)
    @user = user
    @auction = auction
  end

  delegate(
    :bid_count,
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
    :highlighted_bid_amount_as_currency,
    to: :auction
  )

  def auction_status_header
    if auction_won?
      "Winning bid (#{auction.highlighted_bidder_name(user)}):"
    else
      auction.highlighted_bid_label
    end
  end

  def auction_status_partial
    auction.partial_path('auction_status')
  end

  def current_user_header_partial
    current_user_has_no_sam_verification? ? "/components/no_sam_verification_header" : win_header_partial
  end

  def win_header_partial
    auction.partial_path('win_header')
  end

  def auction_link_text
    "#{auction.bids.count} #{bid_to_plural}"
  end

  def auction_deadline_label
    if auction.over?
      "Auction ended at:"
    else
      "Bid deadline:"
    end
  end

  def auction_formatted_end_time
    auction.end_datetime.strftime("%m/%d/%Y at %I:%M %p %Z")
  end

  def auction_start_label
    auction.over? ? "Auction started at:" : "Bid start time:"
  end

  def auction_formatted_start_time
    auction.start_datetime.strftime("%m/%d/%Y at %I:%M %p %Z")
  end

  def auction_rules_link
    "<a href='#{auction_rules_href}'>Rules for #{auction.formatted_type} auctions</a>".html_safe
  end

  def auction_won?
    auction.over? && auction.bids.any?
  end

  private

  attr_reader :user

  def bid_to_plural
    auction.bids.any? ? "bids" : "bid"
  end

  def current_user_has_no_sam_verification?
    user && !user.sam_accepted?
  end
end
