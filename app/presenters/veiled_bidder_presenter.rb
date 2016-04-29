class VeiledBidderPresenter
  include ActiveModel::SerializerSupport

  def initialize(message: nil)
    @message = message
  end

  def id
    @message
  end

  def created_at
    @message
  end

  def updated_at
    @message
  end

  def github_id
    @message
  end

  def github_login
    @message
  end

  def duns_number
    @message
  end

  def name
    @message
  end

  def email
    @message
  end

  def sam_status
    @message
  end
end
