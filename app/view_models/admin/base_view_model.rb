class Admin::BaseViewModel
  def auctions_nav_class
    ''
  end

  def closed_auctions_nav_class
    ''
  end

  def vendors_nav_class
    ''
  end

  def admins_nav_class
    ''
  end

  def customers_nav_class
    ''
  end

  def needs_attention_auctions_nav_class
    ''
  end

  def needs_attention_auctions_count
    AuctionQuery.new.needs_attention_count
  end

  def new_auction_nav_class
    ''
  end

  def skills_nav_class
    ''
  end
end
