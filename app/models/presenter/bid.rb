module Presenter
  class Bid < SimpleDelegator
    def time
      converted = DcTime.new(created_at).convert
      return null unless converted
      converted.to_s(:long)
    end

    def bidder_duns_number
      bidder.duns_number || null
    end

    def bidder_name
      bidder.name || null
    end

    def null
      Null::NULL
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
