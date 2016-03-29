module Presenter
  module AuctionStatus
    class Expiring < Presenter::AuctionStatus::Open
      def label_class
        'auction-label-expiring'
      end

      def label
        'Expiring'
      end
    end
  end
end
