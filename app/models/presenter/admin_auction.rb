module Presenter
  class AdminAuction
    attr_reader :auction, :pr_auction

    def initialize(auction)
      @auction = auction
      @pr_auction = Presenter::Auction.new(auction)
    end

    delegate :bids, :bids?, :bid_count, :available?, :html_summary,
             :html_description, :current_bid?, :current_bidder_name,
             :current_bidder_duns_number, :current_bid_amount,
             :current_bid_time, :starts_at, :ends_at,
             to: :pr_auction

    delegate :title, :created_at,
             :start_datetime, :end_datetime, :github_repo, :issue_url,
             :summary, :description, :delivery_deadline, :billable_to,
             :start_price, :published, :notes, :delivery_url, :result,
             :cap_proposal_url, :awardee_paid_status, :to_param,
             :model_name, :to_key, :to_model, :type, :id,
             :read_attribute_for_serialization,
             to: :auction
  end
end
