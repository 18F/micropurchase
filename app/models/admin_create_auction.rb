class AdminCreateAuction < Struct.new(:params)
  attr_reader :auction

  def perform
    @auction = Auction.create(attributes)
  end

  private

  def attributes
    {
      title: title,
      description: description,
      github_repo: github_repo,
      issue_url: issue_url,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      start_price: start_price
    }
  end

  [:title, :description, :github_repo, :issue_url].each do |key|
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
    raise ArgumentError.new("Missing or poorly formatted time: '#{time}'") if !parsed_time
    if !time.match(/\d{1,2}:\d{2}/)
      parsed_time = parsed_time.beginning_of_day
    end
    parsed_time.utc
  end

  def start_price
    price = params[:auction][:start_price].to_f
    if price > PlaceBid::BID_LIMIT || price <= 0
      price = PlaceBid::BID_LIMIT
    end
    price
  end
end
