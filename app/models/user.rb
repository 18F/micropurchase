class User < ActiveRecord::Base
  has_many :bids

  validates :credit_card_form_url, url: {allow_blank: true, no_local: true, schemes: ['http', 'https']}
  validates :duns_number, duns_number: true
  validates :email, allow_blank: true, email: true

  def from_oauth_hash(auth_hash)
    set_if_blank('name', auth_hash)
    set_if_blank('email', auth_hash)
    self.github_login = auth_hash[:info][:nickname]
    self.save!
  end

  private

  def set_if_blank(field, auth_hash)
    attribute = field.to_sym

    if send(attribute).blank?
      self.send("#{attribute}=", auth_hash[:info][attribute])
    end
  end
end
