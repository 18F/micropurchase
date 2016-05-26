class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def action_items
    @action_items = Admin::ActionItemsViewModel.new
  end

  def drafts
    auctions = AuctionQuery.new.unpublished.all
    @auctions = auctions.map { |auction| Admin::DraftListItem.new(auction) }
  end
end
