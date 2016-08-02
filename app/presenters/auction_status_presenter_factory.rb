class AuctionStatusPresenterFactory
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def create
    if current_user.decorate.admin?
      AvailableUserIsAdmin.new(auction: auction)
    else
      AvailableUserIsGuest.new(auction: auction)
    end
  end
end

class AvailableUserIsAdmin
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction is accepting bids until #{end_date}."
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end

class AvailableUserIsGuest
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
    "This auction is accepting bids until #{end_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def sign_in_link
    link_to 'Sign in', sign_in_path
  end

  def sign_up_link
    link_to 'sign up', sign_up_path
  end
end
