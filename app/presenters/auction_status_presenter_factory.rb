class AuctionStatusPresenterFactory
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def create
    if available? && admin?
      AvailableUserIsAdmin.new(auction: auction)
    elsif available?
      AvailableUserIsGuest.new(auction: auction)
    elsif current_user.is_a?(Guest)
      FutureUserIsGuest.new(auction: auction)
    elsif admin?
      FutureUserIsAdmin.new(auction: auction)
    else
      FutureUserIsVendor.new(auction: auction)
    end
  end

  private

  def available?
    auction_status.available?
  end

  def admin?
    current_user.decorate.admin?
  end

  def auction_status
    AuctionStatus.new(auction)
  end
end

class AvailableUserIsAdmin
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def to_s
    "This auction is accepting bids until #{end_date}."
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end
end

class AvailableUserIsGuest
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def to_s
    "This auction is accepting bids until #{end_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end

  private

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def sign_in_link
    Url.new(link_text: 'Sign in', path_name: 'sign_in')
  end

  def sign_up_link
    Url.new(link_text: 'sign up', path_name: 'sign_up')
  end
end

class FutureUserIsGuest
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def to_s
    "This auction starts on #{start_date}. #{sign_in_link} or
    #{sign_up_link} with GitHub to bid."
  end

  private

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def sign_in_link
    Url.new(link_text: 'Sign in', path_name: 'sign_in')
  end

  def sign_up_link
    Url.new(link_text: 'sign up', path_name: 'sign_up')
  end
end

class FutureUserIsVendor
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def to_s
    "This auction starts on #{start_date}."
  end

  private

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end
end

class FutureUserIsAdmin
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def to_s
    "This auction is visible to the public but is not currently accepting bids.
    It will open on #{start_date}. If you need to take it down for whatever
    reason, press the unpublish button below. #{link}"
  end

  private

  def link
    link_to(
      "Un-publish",
      admin_auction_published_path(auction),
      method: :patch,
      class: 'usa-button usa-button-outline auction-button'
    )
  end

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end
end
