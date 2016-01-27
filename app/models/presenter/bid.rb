module Presenter
  class Bid < SimpleDelegator
    def time
      Presenter::DcTime.convert_and_format(created_at)
    end

    def veiled_bidder_duns_number(show_user = nil)
      if presenter_auction.available? && bidder != show_user
        '[Withheld]'
      else
        bidder_duns_number
      end
    end

    def bidder_duns_number
      bidder.duns_number || null
    end

    def veiled_bidder_name(show_user = nil)
      if presenter_auction.available? && bidder != show_user
        '[Name withheld until the auction ends]'
      else
        bidder_name
      end
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

      def amount
        NULL
      end
    end
  end
end
