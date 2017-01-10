class User < ActiveRecord::Base
  has_many :bids, foreign_key: 'bidder_id'

  validates :payment_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, presence: true, email: true
  validates :github_id, presence: true
  validates :github_login, presence: true
  validates :sam_status, presence: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def self.from_saml_omniauth(auth)
    return if auth.uid.blank?
    existing_user = find_by(uid: auth.uid) || find_by(email: auth.info.email)

    if existing_user && Admins.verify?(existing_user.github_id)
      existing_user.assign_from_auth(auth)
      existing_user.save
      existing_user
    end
  end

  def decorate
    if Admins.verify?(github_id)
      AdminUserPresenter.new(self)
    else
      UserPresenter.new(self)
    end
  end

  def assign_from_auth(auth)
    self.uid = auth.uid
    self.email = auth.info.email
    self.name = "#{auth.info.first_name} #{auth.info.last_name}"
  end
end
