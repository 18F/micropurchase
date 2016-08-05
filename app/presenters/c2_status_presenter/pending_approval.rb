class C2StatusPresenter::PendingApproval
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def header
    'Pending C2 approval'
  end

  def body
    "This auction has been sent to C2 for approval. You can check on the status
    #{link}."
  end

  private

  def link
    link_to(
      'here',
      auction.c2_proposal_url,
      target: '_blank'
    )
  end
end
