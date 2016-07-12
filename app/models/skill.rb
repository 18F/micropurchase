class Skill < ActiveRecord::Base
  has_and_belongs_to_many :auctions
  validates :name, presence: true, uniqueness: true
end
