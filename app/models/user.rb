class User < ActiveRecord::Base
  has_many :bids, foreign_key: 'bidder_id'

  validates :payment_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, presence: true, email: true
  validates :github_id, presence: true, if: :not_login_user?
  validates :github_login, presence: true, if: :not_login_user?
  validates :sam_status, presence: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def self.from_saml_omniauth(auth)
    existing_login_user = find_by(uid: auth.uid)
    if !existing_login_user
      new_login_user = find_by(email: auth.email)
      if new_login_user
        new_login_user.add_saml(auth)
      end
    end
    existing_login_user || new_login_user
  end

  def add_saml(auth)
    if admin?
      self.uid = auth.uid
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

    assign_attrs(auth.info)
  end

  def guest?
    false
  end

  def admin?
    Admins.verify?(github_id)
  end
  
  private

  def not_login_user?
    uid.blank?
  end

  def assign_attrs(auth_attrs)
    self.email = auth_attrs.email
    self.name = "#{auth_attrs.first_name} #{auth_attrs.last_name}"
  end
end
