require 'sinatra/activerecord'

class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :bidder
end
