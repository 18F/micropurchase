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

    delegate(
      :created_at,
      :delivery_deadline,
      :description,
      :end_datetime,
      :github_repo,
      :id,
      :issue_url,
      :model_name,
      :published,
      :read_attribute_for_serialization,
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
      :future?,
      :expiring?,
      :over?,
      :available?,
      to: :auction_status
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

    def bids?
      bid_count > 0
    end

    def bids
      @bids ||= model.bids.to_a
                     .map {|bid| decorated_bid(bid) }
                     .sort_by(&:created_at)
                     .reverse
    end

    def lowest_bids
      model.lowest_bids.map {|b| decorated_bid(b) }
    end

    def lowest_bid
      decorated_bid(model.lowest_bid)
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

    def starts_in
      time_in_human(model.start_datetime)
    end

    def ends_in
      time_in_human(model.end_datetime)
    end

    def delivery_deadline_expires_in
      time_in_human(model.delivery_deadline)
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

    def human_start_time
      if start_datetime < Time.now
        # this method comes from the included date helpers
        "#{distance_of_time_in_words(Time.now, start_datetime)} ago"
      else
        "in #{distance_of_time_in_words(Time.now, start_datetime)}"
      end
    end

    private

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
