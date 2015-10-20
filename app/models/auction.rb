require 'sinatra/activerecord'

class Auction < ActiveRecord::Base
  has_many :bids
end
