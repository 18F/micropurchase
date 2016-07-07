class Customer < ActiveRecord::Base
  validates :agency_name, presence: true, uniqueness: true
  validates :email, email: true, allow_nil: true

  has_many :auctions

  scope :sorted, -> { order('agency_name ASC') }
end
