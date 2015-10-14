require 'sinatra/activerecord'

class Bidder < ActiveRecord::Base
  has_many :bids
end
