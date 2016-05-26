class Admin::ActionListItem
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def delivery_due_at_expires_in
    HumanTime.new(time: auction.delivery_due_at).relative_time
  end

  def delivery_url
    auction.delivery_url
  end

  def result
    auction.result
  end

  def cap_proposal_url
    auction.cap_proposal_url
  end

  def paid?
    auction.paid?
  end
end
