class User < ActiveRecord::Base
  has_many :bids

  validates :credit_card_form_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, allow_blank: true, email: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def decorate
    UserPresenter.new(self)
  end

  def from_oauth_hash(auth_hash)
    set_if_blank('name', auth_hash)
    set_if_blank('email', auth_hash)
    self.github_login = auth_hash[:info][:nickname]
    save!
  end

  private

  def set_if_blank(field, auth_hash)
    attribute = field.to_sym

    if send(attribute).blank?
      send("#{attribute}=", auth_hash[:info][attribute])
    end
  end
end
