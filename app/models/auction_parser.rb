class AuctionParser < Struct.new(:params, :user)
  def attributes
    {
      awardee_paid_status: auction_params[:awardee_paid_status],
      billable_to: auction_params[:billable_to],
      cap_proposal_url: auction_params[:cap_proposal_url],
      delivery_due_at: delivery_due_at,
      delivery_url: auction_params[:delivery_url],
      description: auction_params[:description],
      ended_at: ended_at,
      github_repo: auction_params[:github_repo],
      issue_url: auction_params[:issue_url],
      notes: auction_params[:notes],
      published: auction_params[:published],
      result: auction_params[:result],
      started_at: started_at,
      start_price: auction_params[:start_price],
      summary: auction_params[:summary],
      title: auction_params[:title],
      type: auction_params[:type],
      user: user
    }.reject { |_key, value| value.nil? }
  end

  private

  def delivery_due_at
    if auction_params.key?(:due_in_days) && auction_params[:due_in_days].present?
      real_days = auction_params[:due_in_days].to_i.business_days
      end_of_workday(real_days.after(ended_at))
    elsif auction_params[:deliery_deadline]
      parse_datetime("delivery_due_at")
    end
  end

  def started_at
    parse_datetime("started_at")
  end

  def ended_at
    parse_datetime("ended_at")
  end

  def parse_datetime(field)
    if auction_params[field]
      DateTimeParser.new(auction_params, field).parse
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
