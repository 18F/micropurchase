class User < ActiveRecord::Base
  has_many :bids, foreign_key: 'bidder_id'

  validates :payment_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, presence: true, email: true
  validates :github_id, presence: true
  validates :github_login, presence: true
  validates :sam_status, presence: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.assign_from_auth(auth)
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

  private

  def assign_attrs(auth_attrs)
    self.email = auth_attrs.email
    self.name = "#{auth_attrs.first_name} #{auth_attrs.last_name}"
  end
end
