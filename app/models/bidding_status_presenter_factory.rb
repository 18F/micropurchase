class BiddingStatusPresenterFactory
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def create
    Object.const_get("BiddingStatusPresenter::#{status_name}").new(auction)
  end

  private

  def status_name
    if bidding_status.expiring?
      'Expiring'
    elsif bidding_status.over?
      'Over'
    elsif bidding_status.future?
      'Future'
    else
      'Available'
    end
  end

  def bidding_status
    @_bidding_status ||= BiddingStatus.new(auction)
  end
end
