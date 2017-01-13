class AuctionParser
  attr_reader :params, :user

  def initialize(params, user)
    @params = params
    @user = user
  end

  def attributes
    @_attributes ||= auction_params.merge(
      delivery_due_at: delivery_due_at,
      ended_at: ended_at,
      started_at: started_at,
      user: user,
      paid_at: paid_at
    ).delete_if { |_key, value| value.nil? }
  end

  def publishing?
    attributes['published'] == 'published'
  end

  def archiving?
    params.key? :archive_auction
  end

  private

  def auction_params
    strong_params.require(:auction).permit(
      :billable_to,
      :c2_proposal_url,
      :c2_status,
      :customer_id,
      :delivery_status,
      :delivery_url,
      :description,
      :github_repo,
      :issue_url,
      :notes,
      :published,
      :purchase_card,
      :start_price,
      :summary,
      :title,
      :type,
      skill_ids: []
    )
  end

  def strong_params
    @_strong_params ||= ActionController::Parameters.new(params)
  end

  def delivery_due_at
    if due_in_days.present?
      real_days = due_in_days.to_i
      DefaultDeadlineDateTime.new(start_time: ended_at, day_offset: real_days).dc_time
    end
  end

  def due_in_days
    params[:auction][:due_in_days]
  end

  def ended_at
    parse_datetime("ended_at")
  end

  def started_at
    parse_datetime("started_at")
  end

  def paid_at
    if params[:auction][:paid_at] == '1'
      Time.current
    end
  end

  def parse_datetime(field)
    if params[:auction][field]
      DateTimeParser.new(params[:auction], field).parse
    end
  end
end
