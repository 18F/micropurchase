module ViewModel
  class AdminAuctionForm < Struct.new(:auction)
    # def general_form_action
    #   "/admin/auctions/new"
    # end
    #
    # def type_partial
    #   "#{type.gsub(/\W/, '_')}_attributes"
    # end
    #
    # def type
    #   auction.type || Auction::TYPES.first
    # end
    #
    # def form_template
    #   if auction.type
    #     'type_form'
    #   else
    #     'general_form'
    #   end
    # end
    #
    # def header
    #   if auction.type
    #     "Create auction"
    #   else
    #     "Start a new auction"
    #   end
    # end
  end
end
