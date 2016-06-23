class Admin::DraftListItem < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def drafts_nav_class
    'usa-current'
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def billable_to
    auction.billable_to
  end

  def started_at
    auction.started_at
  end

  def ended_at
    auction.ended_at
  end

  def start_price
    auction.start_price
  end

  def delivery_due_at
    auction.delivery_due_at
  end
end
