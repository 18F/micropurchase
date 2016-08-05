class C2StatusPresenter::ApprovalNotRequested
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def header
    'C2 approval required'
  end

  def body
    "This auction will be paid for using an 18F purchase card, which cannot be
    used without first being granted approval in C2. #{link}"
  end

  private

  def link
    link_to(
      'Request approval',
      admin_proposals_path(auction_id: auction.id),
      method: :post,
      class: 'usa-button usa-button-outline auction-button'
    )
  end
end
