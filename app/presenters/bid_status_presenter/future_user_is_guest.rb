class BidStatusPresenter::FutureUserIsGuest < BidStatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def body
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
