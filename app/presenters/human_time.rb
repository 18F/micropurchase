class HumanTime
  include ActionView::Helpers::DateHelper

  attr_reader :time, :current_time

  def initialize(time:, current_time: Time.current)
    @time = time
    @current_time = current_time
  end

  def relative_time
    distance = distance_of_time_in_words(current_time, time)
    if time < current_time
      "Ended #{distance} ago"
    else
      "Starts #{distance} from now"
    end
  end

  def relative_time_left
    "Time remaining #{distance_of_time_in_words(current_time, time)}"
  end
end
