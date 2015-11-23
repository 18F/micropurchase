class User < ActiveRecord::Base
  has_many :bids
  validates :email, email: true, allow_blank: true
end
