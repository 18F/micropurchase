class AdminAuctionPresenter < AuctionPresenter
  delegate(
    :awardee_paid_status,
    :billable_to,
    :cap_proposal_url,
    :delivery_url,
    :new_record?,
    :notes,
    :paid?,
    :result,
    :updated_at,
    to: :auction
  )
end
