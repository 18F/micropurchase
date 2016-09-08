class BidStatusPresenter::Base
  attr_reader :auction, :user

  def initialize(auction:, user: nil)
    @auction = auction
    @user = user
  end

  def auction_id
    auction.id
  end

  def header
    ''
  end

  def body
    ''
  end

  def action_partial
    'components/null'
  end

  protected

  def end_date
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def delivery_deadline
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  def sign_in_link
    Url.new(link_text: 'Sign in', path_name: 'sign_in')
  end

  def sign_up_link
    Url.new(link_text: 'sign up', path_name: 'sign_up')
  end

  def winning_amount
    Currency.new(WinningBid.new(auction).find.amount)
  end

  def max_allowed_bid_as_currency
    Currency.new(rules.max_allowed_bid)
  end

  def rules
    @_rules ||= RulesFactory.new(auction).create
  end
end
