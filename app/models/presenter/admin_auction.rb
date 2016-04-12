module Presenter
  class AdminAuction < Presenter::Auction
    delegate :paid?, :billable_to, :notes, :delivery_url, :result,
             :cap_proposal_url, :awardee_paid_status, :new_record?,
             to: :model
  end
end
