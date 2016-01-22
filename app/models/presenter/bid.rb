module Presenter
  class Bid < SimpleDelegator
    def time
      Presenter::DcTime.convert_and_format(created_at)
    end

    # def bidder
    #   Presenter::User.new(model.bidder)
    # end

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

      def amount
        NULL
      end
    end
  end
end
