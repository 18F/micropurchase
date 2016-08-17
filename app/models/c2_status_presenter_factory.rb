class C2StatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.c2_status == 'not_requested'
      C2StatusPresenter::ApprovalNotRequested.new(auction: auction)
    elsif auction.c2_status == 'sent'
      C2StatusPresenter::Sent.new
    elsif auction.c2_status == 'pending'
      C2StatusPresenter::Pending.new(auction: auction)
    elsif auction.c2_status == 'approved'
      C2StatusPresenter::Approved.new(auction: auction)
    else
      C2StatusPresenter::Null.new
    end
  end
end
