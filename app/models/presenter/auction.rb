require 'action_view'

module Presenter
  class Auction < SimpleDelegator
    include ActiveModel::SerializerSupport
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::NumberHelper

    delegate :bidder_name, :bidder_duns_number,
             to: :current_bid, prefix: :current

    def bids?
      bid_count > 0
    end

    def bids
      model.bids.to_a
           .map {|bid| Presenter::Bid.new(bid) }
           .sort_by(&:created_at)
           .reverse
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
      distance = distance_of_time_in_words(Time.now, model.start_datetime)
      if model.start_datetime < Time.now
        "#{distance} ago"
      else
        "in #{distance}"
      end
    end

    def ends_in
      distance = distance_of_time_in_words(Time.now, model.end_datetime)
      if model.end_datetime < Time.now
        "#{distance} ago"
      else
        "in #{distance}"
      end
    end

    def delivery_deadline_expires_in
      distance = distance_of_time_in_words(Time.now, model.delivery_deadline)
      if model.delivery_deadline < Time.now
        "#{distance} ago"
      else
        "in #{distance}"
      end
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
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                            no_intra_emphasis: true,
                                            autolink: true,
                                            tables: true,
                                            fenced_code_blocks: true,
                                            lax_spacing: true)
    end
    
    def model
      __getobj__
    end
  end
end
