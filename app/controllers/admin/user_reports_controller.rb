class Admin::UserReportsController < Admin::BaseController
  def index
    @users = User.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment"
        send_data(
          UserExport.new.export_csv,
          filename: "micropurchase_users.csv"
        )
      end
    end
  end
end
