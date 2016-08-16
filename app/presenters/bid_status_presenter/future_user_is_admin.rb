class BidStatusPresenter::FutureUserIsAdmin < BidStatusPresenter::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def body
    "This auction is visible to the public but is not currently accepting bids.
    It will open on #{start_date}. If you need to take it down for whatever
    reason, press the unpublish button below. #{link}"
  end

  private

  def link
    link_to(
      "Un-publish",
      admin_auction_published_path(auction),
      method: :patch,
      class: 'usa-button usa-button-outline auction-button'
    )
  end
end
