class SmallBusinessEligibility
  def eligible?(user)
    InSamEligibility.new.eligible?(user) &&
      user.small_business?
  end
end
