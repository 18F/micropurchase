class Auction < ActiveRecord::Base
  has_many :bids
end
