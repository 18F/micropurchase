class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :bidder, class_name: 'User'

  validates :amount, presence: true
  validates :auction, presence: true
  validates :bidder, presence: true

  def bidder_name
    bidder.name
  end

  def decorated_bidder
    UserPresenter.new(bidder)
  end
end
