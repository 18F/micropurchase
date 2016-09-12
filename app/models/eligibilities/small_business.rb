class Eligibilities::SmallBusiness < Eligibilities::InSam
  def eligible?(user)
    super && user.small_business?
  end

  def label
    'Small-business only'
  end
end
