module Eligibility
  class SmallBusiness
    def eligible?(user)
      Eligibility::InSam.new.eligible?(user) &&
      user.small_business?
    end
  end
end
