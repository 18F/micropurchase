module ViewModel
  module AuctionStatus
    class Future < Struct.new(:auction)
      include ActionView::Helpers::NumberHelper

      def status
        'Closed'
      end
      
      def label_class
        'auction-label-future'
      end

      def label
        'Coming Soon'
      end

      def tag_data_value_status
        auction.human_start_time
      end

      def tag_data_label_2
        "Starting bid"
      end

      def tag_data_value_2
        number_to_currency(auction.start_price)
      end
    end
  end
end
