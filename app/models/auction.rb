class Auction < ActiveRecord::Base
  has_many :bids
  has_many :bidders, through: :bids
  enum result: {not_applicable: 0, accepted: 1, rejected: 2}
  enum type: {single_bid: 0, multi_bid: 1}
  enum awardee_paid_status: {not_paid: 0, paid: 1}
  enum published: {unpublished: 0, published: 1}

  # Disable STI
  self.inheritance_column = :__disabled
end
