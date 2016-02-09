module Presenter
  class Auction < SimpleDelegator
    include ActiveModel::SerializerSupport
    include ActionView::Helpers::DateHelper

    def current_bid?
      current_bid_record != nil
    end

    def current_bid
      return Presenter::Bid::Null.new unless current_bid_record
      Presenter::Bid.new(current_bid_record)
    end

    def current_max_bid
      if current_bid.is_a?(Presenter::Bid::Null)
        return start_price - PlaceBid::BID_INCREMENT
      else
        return current_bid.amount - PlaceBid::BID_INCREMENT
      end
    end

    def current_bid_amount
      current_bid.amount
    end

    def current_bidder_name
      current_bid.bidder_name
    end

    def current_bidder_duns_number
      current_bid.bidder_duns_number
    end

    def current_bid_time
      current_bid.time
    end

    def bids?
      bids.size > 0
    end

    def bids
      model.bids.to_a.
        map {|bid| Presenter::Bid.new(bid) }.
        sort_by(&:created_at).
        reverse
    end

    def starts_at
      Presenter::DcTime.convert_and_format(model.start_datetime)
    end

    def ends_at
      Presenter::DcTime.convert_and_format(model.end_datetime)
    end

    # rubocop:disable Style/DoubleNegation
    def available?
      !!(
        (model.start_datetime && (model.start_datetime <= Time.now)) &&
          (model.end_datetime && (model.end_datetime >= Time.now))
      )
    end
    # rubocop:enable Style/DoubleNegation

    def over?
      model.end_datetime < Time.now
    end

    def future?
      model.start_datetime > Time.now
    end

    def expiring?
      available? && model.end_datetime < 12.hours.from_now
    end

    def user_is_winning_bidder?(user)
      return false unless current_bid?
      user.id == current_bid.bidder_id
    end

    def user_is_bidder?(user)
      bids.detect {|b| user.id == b.bidder_id } != nil
    end

    def html_description
      return '' if description.blank?
      markdown.render(description)
    end

    def html_summary
      return '' if summary.blank?
      markdown.render(summary)
    end

    def status
      if available?
        'Open'
      else
        'Closed'
      end
    end


    delegate :label_class, :label,
      to: :status_presenter

    def human_start_time
      if start_datetime < Time.now
        # this method comes from the included date helpers
        "#{distance_of_time_in_words(Time.now, start_datetime)} ago"
      else
        "in #{distance_of_time_in_words(Time.now, start_datetime)}"
      end
    end

    private

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

    def markdown
      # FIXME: Do we want the lax_spacing?
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
