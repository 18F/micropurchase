module Presenter
  class Bid < SimpleDelegator
    def time
      Presenter::DcTime.convert_and_format(created_at)
    end

    def bidder_duns_number
      if presenter_auction.available?
        '[Witheld]'
      else
        bidder.duns_number || null
      end
    end

    def bidder_name
      if presenter_auction.available?
        '[Name witheld until the auction ends]'
      else
        bidder.name || null
      end
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
