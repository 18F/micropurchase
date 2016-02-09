module ViewModel
  class AuctionsIndex < Struct.new(:current_user, :auctions_query)
    def auctions
      @auctions ||= auctions_query.map  {|auction| Presenter::Auction.new(auction) }
    end
  end
end
