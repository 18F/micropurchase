class InSamEligibility
  def eligible?(user)
    user.sam_accepted?
  end
end
