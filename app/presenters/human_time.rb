class HumanTime
  include ActionView::Helpers::DateHelper

  attr_reader :time, :current_time

  def initialize(time:, current_time: Time.current)
    @time = time
    @current_time = current_time
  end

  def relative_time
    distance = distance_of_time_to_now
    if time < current_time
      "#{distance} ago"
    else
      "in #{distance}"
    end
  end

  def distance_of_time_to_now
    time_ago_in_words(time)
  end

  def distance_of_time
    distance_of_time_in_words(time)
  end
end
