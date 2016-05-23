require 'action_view'

class AuctionPresenter
  include ActiveModel::SerializerSupport
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  def initialize(auction)
    @auction = auction
  end

  delegate(
    :billable_to,
    :cap_proposal_url,
    :created_at,
    :delivery_due_at,
    :delivery_url,
    :description,
    :ended_at,
    :github_repo,
    :id,
    :issue_url,
    :model_name,
    :published,
    :read_attribute_for_serialization,
    :started_at,
    :start_price,
    :summary,
    :title,
    :to_key,
    :to_model,
    :to_param,
    :type,
    :updated_at,
    :lowest_bid,
    :reload,
    to: :auction
  )

  delegate(
    :amount,
    :time,
    to: :lowest_bid,
    prefix: :lowest_bid
  )

  delegate(
    :bidder_duns_number,
    :bidder_name,
    to: :lowest_bid,
    prefix: :lowest
  )

  delegate(
    :auction_rules_href,
    :formatted_type,
    :highlighted_bid,
    :highlighted_bid_label,
    :max_allowed_bid,
    :partial_path,
    :show_bids?,
    :user_can_bid?,
    :veiled_bids,
    :winning_bid,
    to: :auction_rules
  )

  delegate(
    :small_business?,
    to: :start_price_thresholds
  )

  def bids?
    bid_count > 0
  end

  def bids
    @bids ||= auction.bids.order(created_at: :desc).map { |bid| decorated_bid(bid) }
  end

  def lowest_bids
    auction.lowest_bids.map { |b| decorated_bid(b) }
  end

  def lowest_bid
    decorated_bid(auction.lowest_bid)
  end

  def bid_count
    bids.size
  end

  def formatted_start_time
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def formatted_end_time
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def formatted_delivery_due_at
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  def relative_start_time
    time_in_human(auction.started_at)
  end

  def relative_time_left
    "#{distance_of_time_in_words(Time.current, auction.ended_at)} left"
  end

  def time_open
    "Time remaining: #{distance_of_time_in_words(Time.current, auction.started_at)}"
  end

  def time_over
    "Auction ended #{distance_of_time_in_words(auction.started_at, Time.current)} ago"
  end

  def time_future
    "Auction starts #{distance_of_time_in_words(Time.current, auction.ended_at)} from now"
  end

  def delivery_deadline_expires_in
    time_in_human(auction.delivery_due_at)
  end

  def winning_bidder_id
    winning_bid.bidder_id
  end

  def html_description
    return '' if description.blank?
    markdown.render(description)
  end

  def html_summary
    return '' if summary.blank?
    markdown.render(summary)
  end

  def url
    root_url = if Rails.env.development? || Rails.env.test?
                 ENV['ROOT_URL']
               else
                 VCAPApplication.application_uris.first
               end
    "#{root_url}/auctions/#{id}"
  end

  def eligibility_label
    auction_rules.eligibility.label
  end

  private

  attr_reader :auction

  def auction_rules
    @auction_rules ||= RulesFactory.new(self).create
  end

  def markdown
    # FIXME: Do we want the lax_spacing?
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                          no_intra_emphasis: true,
                                          autolink: true,
                                          tables: true,
                                          fenced_code_blocks: true,
                                          lax_spacing: true)
  end

  def time_in_human(time)
    distance = distance_of_time_in_words(Time.current, time)
    if time < Time.current
      "#{distance} ago"
    else
      "in #{distance}"
    end
  end

  def auction_status
    AuctionStatus.new(auction)
  end

  def start_price_thresholds
    @start_price_thresholds ||= StartPriceThresholds.new(start_price)
  end

  def decorated_bid(bid)
    if bid.present?
      BidPresenter.new(bid)
    else
      NullBidPresenter.new
    end
  end
end
