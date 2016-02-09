module Presenter
  module AuctionStatus
    class Over < Struct.new(:auction)
      def label_class
        'auction-label-over'
      end

      def label
        'Closed'
      end

      def status_tag_data
        label
      end
    end
  end
end
