module AuctionsHelper

  def show_bid_button_unless_auction_over(auction)
    return if auction.over?

    content_tag :p do 
      link_to "Bid >>", new_auction_bid_path(auction), {class: "usa-button"}
    end
  end

end