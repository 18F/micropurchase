class Admin::DashboardsController < ApplicationController
  before_filter :require_admin

  def index
  end

  def action_items
    @complete_and_successful = AuctionQuery.new.complete_and_successful
    @payment_pending = AuctionQuery.new.payment_pending
    @payment_needed = AuctionQuery.new.payment_needed
    @evaluation_needed = AuctionQuery.new.evaluation_needed
    @delivery_past_due = AuctionQuery.new.delivery_past_due
  end

  def drafts
    @auctions = AuctionQuery.new.unpublished.all
  end
end
