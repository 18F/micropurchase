class User < ActiveRecord::Base
  has_many :bids
end
