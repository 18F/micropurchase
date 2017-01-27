class CreateAuction
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def perform
    build_auction
    save_auction

    auction
  end

  private

  attr_reader :params, :current_user, :auction

  def build_auction
    @auction ||= BuildAuction.new(params, current_user).perform
  end

  def save_auction
    SaveAuction.new(auction).perform
  end
end
