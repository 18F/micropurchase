module Admin
  class AuctionSerializer < ActiveModel::Serializer
    has_many :bids, serializer: Admin::BidSerializer

    attributes :issue_url,
               :github_repo,
               :start_price,
               :start_datetime,
               :end_datetime,
               :delivery_deadline,
               :delivery_url,
               :cap_proposal_url,
               :awardee_paid_status,
               :title,
               :description,
               :id,
               :created_at,
               :updated_at,
               :notes,
               :summary,
               :billable_to

    def delivery_deadline
      object.delivery_deadline.iso8601
    end

    def created_at
      object.created_at.iso8601
    end

    def updated_at
     object.created_at.iso8601
    end

    def end_datetime
      object.end_datetime.iso8601
    end

    def start_datetime
      object.start_datetime.iso8601
    end
  end
end
