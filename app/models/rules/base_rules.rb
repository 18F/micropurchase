class Rules::BaseRules < Struct.new(:auction)
  def partial_path(name, base_dir = 'auctions')
    "#{base_dir}/#{partial_prefix}/#{name}.html.erb"
  end

  def user_can_bid?(user)
    auction_available? && user.present? && user.sam_accepted?
  end

  def partial_prefix
    fail NotImplementedError
  end

  def auction_available?
    AuctionStatus.new(auction).available?
  end
end
