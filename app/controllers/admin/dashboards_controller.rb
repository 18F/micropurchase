module Admin
  class DashboardsController < ApplicationController
    before_filter :require_admin

    def index
    end

    def action_items
      @complete_and_successful = to_presenter(AuctionQuery.new.complete_and_successful)
      @payment_pending = to_presenter(AuctionQuery.new.payment_pending)
      @payment_needed = to_presenter(AuctionQuery.new.payment_needed)
      @evaluation_needed = to_presenter(AuctionQuery.new.evaluation_needed)
      @delivery_past_due = to_presenter(AuctionQuery.new.delivery_past_due)
    end

    def drafts
      @auctions = to_presenter(AuctionQuery.new.unpublished.all)
    end

    private

    def to_presenter(auctions)
      auctions.map {|a| Presenter::AdminAuction.new(a) }
    end
  end
end
