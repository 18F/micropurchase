module ViewModel
  module AuctionStatus
    class Expiring < ViewModel::AuctionStatus::Open
      def label_class
        'auction-label-expiring'
      end

      def label
        'Expiring'
      end
    end
  end
end
