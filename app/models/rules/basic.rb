class Rules::Basic < Struct.new(:auction)
  def winning_bid
    auction.lowest_bid
  end

  def veiled_bids(user)
    auction.bids.order(created_at: :desc)
  end

  def user_can_bid?(user)
    auction.available? && user.present? && user.sam_accepted?
  end

  def max_allowed_bid
    if auction.lowest_bid.present?
      auction.lowest_bid_amount - PlaceBid::BID_INCREMENT
    else
      auction.start_price - PlaceBid::BID_INCREMENT
    end
  end

  def highlighted_bid(user = nil)
    auction.lowest_bid
  end

  def show_bids?
    true
  end

  def partial_path(name, base_dir = 'auctions')
    if partial_prefix.blank?
      "#{base_dir}/#{name}.html.erb"
    else
      "#{base_dir}/#{partial_prefix}/#{name}.html.erb"
    end
  end

  def partial_prefix
    'multi_bid'
  end

  def formatted_type
    'multi-bid'
  end

  def rules_type
    'basic'
  end

  def highlighted_bid_label
    'Current bid:'
  end

  def auction_rules_href
    '/auctions/rules/multi-bid'
  end
end
