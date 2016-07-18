class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :bidder, class_name: 'User'

  def bidder?
    !bidder.nil?
  end

  def bidder_name
    bidder.name
  end
end
