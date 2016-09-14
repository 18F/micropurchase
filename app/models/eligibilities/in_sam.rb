class Eligibilities::InSam
  def eligible?(user)
    user.sam_accepted? && not_admin?(user)
  end

  def label
    'SAM.gov only'
  end

  private

  def not_admin?(user)
    !Admins.verify?(user.github_id)
  end
end
