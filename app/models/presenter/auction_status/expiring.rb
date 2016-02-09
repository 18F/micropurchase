module Presenter
  module AuctionStatus
    class Expiring < Struct.new(:auction)
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::NumberHelper

      def label_class
        'auction-label-expiring'
      end

      def label
        'Expiring'
      end

      def tag_data_value_status
        "#{distance_of_time_in_words(Time.now, auction.end_datetime)} left"
      end

      def tag_data_label_2
        "Bidding"
      end

      def tag_data_value_2
        "#{number_to_currency(auction.current_bid_amount)} - #{auction.bids.length} bids"
      end
    end
  end
end
