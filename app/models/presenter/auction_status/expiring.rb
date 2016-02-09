module Presenter
  module AuctionStatus
    class Expiring < Struct.new(:auction)
      include ActionView::Helpers::DateHelper

      def label_class
        'auction-label-expiring'
      end

      def label
        'Expiring'
      end

      def status_tag_data
        "#{distance_of_time_in_words(Time.now, auction.end_datetime)} left"
      end
    end
  end
end
