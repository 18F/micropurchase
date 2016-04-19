class User < ActiveRecord::Base
  has_many :bids
  validates :email, email: true, allow_blank: true
  validates :duns_number, format: { with: /\A\d{8,13}\z/ }
end
