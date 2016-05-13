class Rules::BaseRules < Struct.new(:auction, :eligibility)
  def partial_path(name, base_dir = 'auctions')
    "#{base_dir}/#{partial_prefix}/#{name}.html.erb"
  end

  def user_can_bid?(user)
    auction.available? &&
    user.present? &&
    eligibility.eligible?(user)
  end

  def partial_prefix
    fail NotImplementedError
  end
end
