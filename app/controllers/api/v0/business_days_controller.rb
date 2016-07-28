class Api::V0::BusinessDaysController < ApiController
  def show
    real_days = params[:day_count].to_i.business_days
    datetime = real_days.after(DateTime.parse("#{params[:date]} #{params[:time]}"))

    render json: { date: DcTimePresenter.format(datetime) }
  end
end
