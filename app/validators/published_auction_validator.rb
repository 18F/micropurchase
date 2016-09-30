class PublishedAuctionValidator < ActiveModel::Validator
  def validate(auction)
    if auction.published_was == 'unpublished'
      validate_budget_approval_for_default_pcard(auction)
      validate_start_date_before_end_date(auction)
      validate_start_date_in_future(auction)
    end
  end

  private

  def validate_budget_approval_for_default_pcard(auction)
    if auction.purchase_card == 'default' && auction.c2_status != 'budget_approved'
      auction.errors.add(:c2_status, "is not budget approved")
    end
  end

  def validate_start_date_before_end_date(auction)
    if auction.started_at > auction.ended_at
      auction.errors.add(
        :base,
        "You must specify an auction end date/time that comes after the auction start date/time."
      )
    end
  end

  def validate_start_date_in_future(auction)
    if auction.started_at < Time.current
      auction.errors.add(
        :base,
        "You must specify an auction start date/time that is after today."
      )
    end
  end
end
