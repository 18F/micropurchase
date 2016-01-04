class Auction < ActiveRecord::Base
  has_many :bids
  has_many :bidders, through: :bids

  scope :in_reverse_chron_order, -> { order('end_datetime DESC') }
  scope :with_bids, -> { includes(:bids) }
end
