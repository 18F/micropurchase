class BidStatusPresenter::Base
  def header
    ''
  end

  def body
    ''
  end

  protected

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

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
