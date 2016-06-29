class UserQuery
  def initialize(relation = User.all)
    @relation = relation.extending(Scopes)
  end

  [
    :with_bids,
    :in_sam,
    :small_business
  ].each do |key|
    define_method key do
      @relation.send(key)
    end
  end

  module Scopes
    def with_bids
      includes(:bids).where.not(bids: { bidder_id: nil })
    end

    def in_sam
      where(sam_status: 1)
    end

    def small_business
      where(small_business: true)
    end
  end
end
