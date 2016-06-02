class User < ActiveRecord::Base
  has_many :bids, foreign_key: 'bidder_id'

  validates :credit_card_form_url, url: { allow_blank: true, no_local: true, schemes: %w(http https) }
  validates :duns_number, duns_number: true
  validates :email, allow_blank: true, email: true

  enum sam_status: { duns_blank: 0, sam_accepted: 1, sam_rejected: 2, sam_pending: 3 }

  def decorate
    UserPresenter.new(self)
  end
end
