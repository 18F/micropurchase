class AuctionParser < Struct.new(:params)
  def attributes
    general_attributes.merge(
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      start_price: start_price
    )
  end

  def general_attributes
    {
      awardee_paid_status: params[:awardee_paid_status],
      billable_to: params[:billable_to],
      cap_proposal_url: params[:cap_proposal_url],
      delivery_deadline: params[:delivery_deadline],
      delivery_url: params[:delivery_url],
      description: params[:description],
      github_repo: params[:github_repo],
      issue_url: params[:issue_url],
      notes: params[:notes],
      published: params[:published],
      result: params[:result],
      summary: params[:summary],
      title: params[:title],
      type: params[:type],
    }
  end

  def delivery_deadline
    if params.has_key?(:due_in_days) && params[:due_in_days].present?
      real_days = params[:due_in_days].to_i.business_days
      end_of_workday(real_days.after(DateTime.new(end_datetime)))
    elsif params[:deliery_deadline]
      parse_datetime("delivery_deadline")
    end
  end

  def start_datetime
    if params[:start_datetime]
      parse_datetime("start_datetime")
    end
  end

  def end_datetime
    if params[:end_datetime]
      parse_datetime("end_datetime")
    end
  end

  def start_price
    price = params[:start_price].to_f
    if price > PlaceBid::BID_LIMIT || price <= 0
      price = PlaceBid::BID_LIMIT
    end

    price
  end

  private

  def end_of_workday(date)
    cob = Time.parse(BusinessTime::Config.end_of_workday)
    Time.mktime(date.year, date.month, date.day, cob.hour, cob.min, cob.sec)
  end

  def parse_datetime(field)
    Time.zone.local(*(1..5).map { |i| params["#{field}(#{i}i)"] })
  end
end
