module Presenter
  class Bid < SimpleDelegator
    include ActionView::Helpers::NumberHelper

    def time
      Presenter::DcTime.convert_and_format(created_at)
    end

    def veiled_bidder_attribute(attribute, show_user = nil, message: nil)
      if presenter_auction.available? && bidder != show_user
        message
      else
        bidder.send(attribute) || null
      end
    end

    def veiled_bidder(show_user = nil, message: nil)
      if presenter_auction.available? && bidder != show_user
        Presenter::VeiledBidder.new(message: message)
      else
        bidder
      end
    end

    def display?
      true
    end

    def bidder_id
      bidder.id || null
    end

    def bidder_duns_number
      bidder.duns_number || null
    end

    def bidder_name
      bidder.name || null
    end

    def presenter_auction
      @presenter_auction ||= Presenter::Auction.new(auction)
    end

    def null
      Null::NULL
    end

    def amount_to_currency
      number_to_currency(amount)
    end

    def amount_to_currency_with_asterisk
      return "#{amount_to_currency} *" if is_winning?
      return amount_to_currency
    end

    def is_winning?
      model.id == presenter_auction.winning_bid_id
    end

    def winning_status
      if presenter_auction.single_bid? && presenter_auction.available?
        return 'n/a'
      else
        is_winning?
      end
    end

    def ==(other)
      return false unless other.is_a?(Presenter::Bid)
      self.id == other.id
    end

    def model
      __getobj__
    end

    class Null
      NULL = "&nbsp;".html_safe

      def time
        NULL
      end

      def bidder_duns_number
        NULL
      end

      def bidder_name
        NULL
      end

      def display?
        false
      end

      def bidder_id
        nil
      end

      def id
        nil
      end

      def amount
        NULL
      end
    end
  end
end
