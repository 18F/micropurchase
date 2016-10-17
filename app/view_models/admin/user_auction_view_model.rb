class Admin::UserAuctionViewModel < UserAuctionViewModel
  def skills
    auction.sorted_skill_names.join(', ')
  end

  def accepted_label
    if user_won? && auction_accepted?
      'Yes'
    elsif user_won?
      'No'
    else
      NA_RESPONSE_STRING
    end
  end

  private

  def auction_accepted?
    auction.accepted?
  end
end
