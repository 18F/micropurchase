module Eligibility
  class InSam
    def eligible?(user)
      user.sam_accepted?
    end
  end
end
