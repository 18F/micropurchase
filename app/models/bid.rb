class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :bidder, class_name: 'User'

  def bidder_name
    bidder.name
  end

  def decorated_bidder
    UserPresenter.new(bidder)
  end
end
