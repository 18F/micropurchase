require 'action_view'

# This is a wrapper around the basic AR model and should be used for
# selecting and rendering raw data from the model object.
module Presenter
  class Auction
    include ActiveModel::SerializerSupport
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::NumberHelper

    def initialize(auction)
      @auction = auction
    end

    def max_allowed_bid
      if lowest_bid.is_a?(Presenter::Bid::Null)
        return start_price - PlaceBid::BID_INCREMENT
      else
        return lowest_bid.amount - PlaceBid::BID_INCREMENT
      end
    end

    delegate(
      :created_at,
      :delivery_deadline,
      :description,
      :end_datetime,
      :github_repo,
      :id,
      :issue_url,
      :model_name,
      :multi_bid?,
      :published,
      :read_attribute_for_serialization,
      :single_bid?,
      :start_datetime,
      :start_price,
      :summary,
      :title,
      :to_key,
      :to_model,
      :to_param,
      :type,
      :updated_at,
      to: :model
    )

    delegate :amount, :time,
             to: :lowest_bid, prefix: :lowest_bid

    delegate :bidder_name, :bidder_duns_number,
             to: :lowest_bid, prefix: :lowest

    delegate(
      :future?,
      :expiring?,
      :over?,
      :available?,
      to: :auction_status
    )

    def bids?
      bid_count > 0
    end

    def bids
      @bids ||= model.bids.to_a
        .map {|bid| decorated_bid(bid) }
        .sort_by(&:created_at)
        .reverse
    end

    def veiled_bids(user)
      # For single bid auctions, we reveal no bids if the auction is running
      # For multi bid auctions, we let the bids go through, but depend on
      # Presenter::Bid to veil certain attributes.

      # redact all bids if auction is still running and type is single bid
      if available? && model.single_bid?
        return [] if user.nil?
        return bids.select {|bid| bid.bidder_id == user.id}
      end

      # otherwise, return all the bids
      bids
    end

    def bid_count
      bids.size
    end

    def starts_at
      Presenter::DcTime.convert_and_format(model.start_datetime)
    end

    def ends_at
      Presenter::DcTime.convert_and_format(model.end_datetime)
    end

    def formatted_type
      return 'multi-bid'  if model.type == 'multi_bid'
      return 'single-bid' if model.type == 'single_bid'
    end

    def type
      model.type
    end

    def starts_in
      time_in_human(model.start_datetime)
    end

    def ends_in
      time_in_human(model.end_datetime)
    end

    def delivery_deadline_expires_in
      time_in_human(model.delivery_deadline)
    end

    def winning_bid
      decorated_bid(model.winning_bid)
    end

    def lowest_bid
      decorated_bid(model.lowest_bid)
    end

    def winning_bidder_id
      model.winning_bid.bidder_id
    end

    def html_description
      return '' if description.blank?
      markdown.render(description)
    end

    def html_summary
      return '' if summary.blank?
      markdown.render(summary)
    end

    def human_start_time
      if start_datetime < Time.now
        # this method comes from the included date helpers
        "#{distance_of_time_in_words(Time.now, start_datetime)} ago"
      else
        "in #{distance_of_time_in_words(Time.now, start_datetime)}"
      end
    end

    private

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
      distance = distance_of_time_in_words(Time.now, time)
      if time < Time.now
        "#{distance} ago"
      else
        "in #{distance}"
      end
    end

    def auction_status
      AuctionStatus.new(model)
    end

    def decorated_bid(bid)
      if bid.present?
        Presenter::Bid.new(bid)
      else
        Presenter::Bid::Null.new
      end
    end

    def model
      @auction
    end
  end
end
