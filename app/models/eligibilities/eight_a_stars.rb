module Eligibility
  class EightAStars
    def eligible?(user)
      Eligibility::InSam.new(user).eligible?
      user.eight_a_stars?
    end
  end
end
