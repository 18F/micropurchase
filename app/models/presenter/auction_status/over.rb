module Presenter
  module AuctionStatus
    class Over < Struct.new(:auction)
      include ActionView::Helpers::NumberHelper

      def label_class
        'auction-label-over'
      end

      def label
        'Closed'
      end

      def tag_data_value_status
        label
      end

      def tag_data_label_2
        "Winning Bid"
      end

      def tag_data_value_2
        number_to_currency(auction.current_bid_amount)
      end
    end
  end
end
