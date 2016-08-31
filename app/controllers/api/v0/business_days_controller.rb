class Api::V0::BusinessDaysController < ApiController
  def show
    real_days = params[:day_count].to_i
    datetime = DefaultDeadlineDateTime.parse("#{params[:date]} #{params[:time]}", real_days).dc_time

    render json: { date: DcTimePresenter.format(datetime) }
  end
end
