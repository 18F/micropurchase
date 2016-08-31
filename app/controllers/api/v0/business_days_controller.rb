class Api::V0::BusinessDaysController < ApiController
  def show
    real_days = params[:day_count].to_i
    time = DcTimePresenter.parse("#{params[:date]} #{params[:time]}")
    datetime = DefaultDeadlineDateTime.new(start_time: time, day_offset: real_days).dc_time

    render json: { date: DcTimePresenter.format(datetime) }
  end
end
