module Presenter
  class AdminAuction < Presenter::Auction
    delegate(
      :awardee_paid_status,
      :billable_to,
      :cap_proposal_url,
      :delivery_url,
      :due_in_days,
      :new_record?,
      :notes,
      :paid?,
      :result,
      to: :model
    )
  end
end
