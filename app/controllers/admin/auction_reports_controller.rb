class Admin::AuctionReportsController < ApplicationController
  before_filter :require_admin

  def show
    @auction = Auction.find(params[:id])

    respond_to do |format|
      format.csv do
        begin
          response.headers['Content-Type'] = 'text/csv'
          response.headers['Content-Disposition'] = "attachment"
          send_data(
            WinningBidderExport.new(@auction).export_csv,
            filename: "winning_bidder_info_for_auction_#{@auction.id}.csv"
          )
        rescue WinningBidderExport::Error
          redirect_to :back
          flash[:error] = I18n.t('controllers.admin.auction_reports.show.error')
        end
      end
    end
  end
end
