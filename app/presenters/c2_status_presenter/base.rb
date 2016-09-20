class C2StatusPresenter::Base
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def action_partial
    'components/null'
  end

  def status
    ''
  end

  def header
    ''
  end

  def body
    ''
  end

  def alert_css_class
    'usa-alert-info'
  end

  def winner_url
    Url.new(
      link_text: winner_name,
      path_name: 'admin_user',
      params: { id: winner.id }
    )
  end

  def winner_name
    winner.name || winner.github_login
  end

  def winner
    winning_bid.bidder
  end

  def winning_bid
    @_winning_bid ||= WinningBid.new(auction).find
  end
end
