class AuctionParser < Struct.new(:params)
  def attributes
    general_attributes.merge({
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      start_price: start_price
    })
  end

  def general_attributes
    {
      type: type,
      title: title,
      description: description,
      summary: summary,
      github_repo: github_repo,
      issue_url: issue_url,
    }
  end

  [:type, :title, :description, :summary, :github_repo, :issue_url].each do |key|
    define_method key do
      params[:auction][key]
    end
  end

  def start_datetime
    parse_time(params[:auction][:start_datetime])
  end

  def end_datetime
    parse_time(params[:auction][:end_datetime])
  end

  def parse_time(time)
    parsed_time = Chronic.parse(time)
    fail ArgumentError, "Missing or poorly formatted time: '#{time}'" unless parsed_time

    unless time.match(/\d{1,2}:\d{2}/)
      parsed_time = parsed_time.beginning_of_day
    end
    parsed_time.utc
  end

  def start_price
    price = params[:auction][:start_price].to_f
    price = PlaceBid::BID_LIMIT if price > PlaceBid::BID_LIMIT || price <= 0

    price
  end
end
