class AuctionParser < Struct.new(:params, :user)
  def attributes
    general_attributes.merge(
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      user: user
    )
  end

  def general_attributes
    {
      type: type,
      title: title,
      description: description,
      summary: summary,
      github_repo: github_repo,
      issue_url: issue_url,
      delivery_deadline: delivery_deadline,
      delivery_url: delivery_url,
      cap_proposal_url: cap_proposal_url,
      awardee_paid_status: awardee_paid_status,
      published: published,
      notes: notes,
      billable_to: billable_to,
      result: result,
      start_price: start_price
    }
  end

  private

  [
    :type,
    :title,
    :description,
    :summary,
    :github_repo,
    :issue_url,
    :awardee_paid_status,
    :published,
    :awardee_paid_at,
    :delivery_url,
    :cap_proposal_url,
    :notes,
    :billable_to,
    :result,
    :start_price
  ].each do |key|
    define_method key do
      params[:auction][key]
    end
  end

  def delivery_deadline
    if params.key?(:due_in_days)
      real_days = params[:due_in_days].to_i.business_days
      end_of_workday(real_days.after(end_datetime.to_date))
    else
      parse_time(params[:auction][:delivery_deadline])
    end
  end

  def start_datetime
    parse_time(params[:auction][:start_datetime])
  end

  def end_datetime
    parse_time(params[:auction][:end_datetime])
  end

  def parse_time(time)
    return nil if time.nil?
    parsed_time = Chronic.parse(time)
    fail ArgumentError, "Missing or poorly formatted time: '#{time}'" unless parsed_time

    unless time =~ /\d{1,2}:\d{2}/
      parsed_time = parsed_time.beginning_of_day
    end
    parsed_time.utc
  end

  def end_of_workday(date)
    cob = Time.parse(BusinessTime::Config.end_of_workday)
    Time.mktime(date.year, date.month, date.day, cob.hour, cob.min, cob.sec)
  end
end
