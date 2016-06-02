class StatusPresenterFactory
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def create
    "StatusPresenter::#{status_name}".constantize.new(auction)
  end

  private

  def status_name
    if auction_status.expiring?
      'Expiring'
    elsif auction_status.over?
      'Over'
    elsif auction_status.future?
      'Future'
    else
      'Available'
    end
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end
