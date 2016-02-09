module Presenter
  module AuctionStatus
    class Open < Struct.new(:auction)
      include ActionView::Helpers::DateHelper

      def label_class
        'auction-label-open'
      end

      def label
        'Open'
      end

      def status_tag_data
        "#{distance_of_time_in_words(Time.now, auction.end_datetime)} left"
      end
    end
  end
end
