class SmallBusinessEligibility
  def eligible?(user)
    InSamEligibility.new.eligible?(user) &&
      user.small_business?
  end

  def label
    'Small-business only'
  end
end
