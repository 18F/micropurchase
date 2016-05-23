class HumanTime
  include ActionView::Helpers::DateHelper

  attr_reader :time, :current_time

  def initialize(time:, current_time: Time.current)
    @time = time
    @current_time = current_time
  end

  def relative_start_time
    distance = distance_of_time_in_words(current_time, time)
    if time < current_time
      "#{distance} ago"
    else
      "in #{distance}"
    end
  end

  def relative_time_left
    "#{distance_of_time_in_words(current_time, time)} left"
  end
end
