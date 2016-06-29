# Represents a single agency customer
class Customer < ActiveRecord::Base
  validates :agency_name, presence: true
  validates :email, email: true
end
