# Represents a single agency customer
class Customer < ActiveRecord::Base
  validates :agency_name, presence: true, uniqueness: true
  validates :email, email: true, presence: false
end
