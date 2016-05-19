class AuctionParser < Struct.new(:params, :user)
  def attributes
    {
      awardee_paid_status: auction_params[:awardee_paid_status],
      billable_to: auction_params[:billable_to],
      cap_proposal_url: auction_params[:cap_proposal_url],
      delivery_deadline: delivery_deadline,
      delivery_url: auction_params[:delivery_url],
      description: auction_params[:description],
      end_datetime: end_datetime,
      github_repo: auction_params[:github_repo],
      issue_url: auction_params[:issue_url],
      notes: auction_params[:notes],
      published: auction_params[:published],
      result: auction_params[:result],
      start_datetime: start_datetime,
      start_price: auction_params[:start_price],
      summary: auction_params[:summary],
      title: auction_params[:title],
      type: auction_params[:type],
      user: user
    }.reject { |_key, value| value.nil? }
  end

  private

  def delivery_deadline
    if auction_params.key?(:due_in_days) && auction_params[:due_in_days].present?
      real_days = auction_params[:due_in_days].to_i.business_days
      end_of_workday(real_days.after(end_datetime))
    elsif auction_params[:deliery_deadline]
      parse_datetime("delivery_deadline")
    end
  end

  def start_datetime
    parse_datetime("start_datetime")
  end

  def end_datetime
    parse_datetime("end_datetime")
  end

  def parse_datetime(field)
    if auction_params["#{field}(1i)"]
      Time.zone.local(*(1..5).map { |i| auction_params["#{field}(#{i}i)"] })
    end
  end

  def end_of_workday(date)
    cob = Time.parse(BusinessTime::Config.end_of_workday)
    Time.mktime(date.year, date.month, date.day, cob.hour, cob.min, cob.sec)
  end

  def auction_params
    params[:auction]
  end
end
