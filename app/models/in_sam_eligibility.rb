class InSamEligibility
  def eligible?(user)
    user.sam_accepted?
  end

  def label
    'SAM.gov only'
  end
end
