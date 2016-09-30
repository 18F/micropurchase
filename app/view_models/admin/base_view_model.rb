class Admin::BaseViewModel
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

  def needs_attention_count_partial
    if needs_attention_auctions_count > 0
      'admin/needs_attention_auction_count'
    else
      'components/null'
    end
  end

  def new_auction_nav_class
    ''
  end

  def skills_nav_class
    ''
  end
end
