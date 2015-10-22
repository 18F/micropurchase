class User < ActiveRecord::Base
  has_many :bids
  has_paper_trail
end
