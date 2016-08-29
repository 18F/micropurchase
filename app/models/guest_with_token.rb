class GuestWithToken
  attr_reader :auction

  def initialize(token)
    @auction = Auction.find_by_token(token)
  end

  def admin?
    false
  end

  def decorate
    GuestPresenter.new
  end
end
