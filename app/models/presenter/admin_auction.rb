module Presenter
  class AdminAuction
    attr_reader :auction

    def initialize(auction)
      @auction = Presenter::Auction.new(auction)
    end

    delegate :bids, :bids?, :bid_count, :available?, :title, :created_at, :starts_at,
             :ends_at, :start_datetime, :end_datetime, :github_repo, :issue_url, :summary,
             :html_summary, :description, :html_description, :delivery_deadline, :billable_to,
             :start_price, :published, :notes, :delivery_url, :result, :cap_proposal_url,
             :current_bid?, :awardee_paid_status, :current_bidder_name,
             :current_bidder_duns_number, :current_bid_amount, :current_bid_time,
             :to_param, :model_name, :to_key, :to_model, :type, :id, :read_attribute_for_serialization,
             to: :auction
  end
end
