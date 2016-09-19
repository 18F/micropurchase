class Admin::DraftListItem < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def c2_proposal_status
    if auction.purchase_card == 'default'
      c2_proposal_status_presenter.status
    else
      'N/A'
    end
  end

  def started_at
    DcTimePresenter.convert_and_format(auction.started_at)
  end

  def ended_at
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def delivery_due_at
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end

  private

  def c2_proposal_status_presenter
    Object.const_get("C2StatusPresenter::#{auction.c2_status.camelize}").new(auction: auction)
  end
end
