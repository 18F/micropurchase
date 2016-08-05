class C2StatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.c2_approval_status == 'not_requested'
      C2StatusPresenter::ApprovalNotRequested.new(auction: auction)
    elsif auction.c2_approval_status == 'pending_approval'
      C2StatusPresenter::PendingApproval.new(auction: auction)
    else
      C2StatusPresenter::Pending.new
    end
  end
end
