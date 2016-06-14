class User < ActiveRecord::Base
  has_many :bids, foreign_key: 'bidder_id'

  validates :credit_card_form_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, presence: true, email: true
  validates :github_id, presence: true
  validates :github_login, presence: true
  validates :sam_status, presence: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def decorate
    UserPresenter.new(self)
  end
end
