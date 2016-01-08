class User < ActiveRecord::Base
  has_many :bids
  validates :email, email: true, allow_blank: true
  before_save :clear_sam_status_if_duns_changed

  scope :not_in_sam, -> { where(sam_account: false) }

  def save_sam_status
    return if sam_account?
    self.sam_account = registered_on_sam?
    save!
  end
  
  private

  def clear_sam_status_if_duns_changed
    self.sam_account = false if persisted? && duns_number_changed?
    true
  end

  def registered_on_sam?
    self.class.registered_on_sam?(duns: duns_number)
  end

  def self.registered_on_sam?(duns: nil)
    client = Samwise::Client.new
    client.duns_is_in_sam?(duns: duns)
  end
end
