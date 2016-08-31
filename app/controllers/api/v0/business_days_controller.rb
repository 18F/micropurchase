class Api::V0::BusinessDaysController < ApiController
  def show
    real_days = params[:day_count].to_i.business_days
    start_time = DcTimePresenter.parse("#{params[:date]} #{params[:time]}")
    datetime = real_days.after(start_time)

    render json: { date: DcTimePresenter.format(datetime) }
  end
end
