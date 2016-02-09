module Presenter
  module AuctionStatus
    class Future < Struct.new(:auction)
      def label_class
        'auction-label-future'
      end

      def label
        'Coming Soon'
      end

      def status_tag_data
        auction.human_start_time
      end
    end
  end
end
