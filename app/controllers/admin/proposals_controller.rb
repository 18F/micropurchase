class Admin::ProposalsController < Admin::BaseController
  def create
    if should_create_c2_proposal?
      auction.update(c2_status: :sent)
      CreateC2ProposalJob.perform_later(auction.id)
      flash[:success] = I18n.t('controllers.admin.proposals.create.success')
    else
      flash[:error] = I18n.t('controllers.admin.proposals.create.failure')
    end

    redirect_to admin_auction_path(auction)
  end

  private

  def should_create_c2_proposal?
    auction.c2_proposal_url.blank? &&
      auction.purchase_card == "default"
  end

  def auction
    @_auction ||= Auction.find(params[:auction_id])
  end
end
