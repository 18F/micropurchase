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
end
