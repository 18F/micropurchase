class User < ActiveRecord::Base
  has_many :bids

  validates :credit_card_form_url, url: {allow_blank: true, no_local: true, schemes: ['http', 'https']}
  validates :duns_number, duns_number: true
  validates :email, allow_blank: true, email: true
end
