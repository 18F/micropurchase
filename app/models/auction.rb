class Auction < ActiveRecord::Base
  has_many :bids
  has_many :bidders, through: :bids

  # enums are a premature optimization, great performance, but can obfuscate.
  # worth spending time to eliminate these:
  enum result: {not_applicable: 0, accepted: 1, rejected: 2}
  enum type: {single_bid: 0, multi_bid: 1}
  enum awardee_paid_status: {not_paid: 0, paid: 1}
  enum published: {unpublished: 0, published: 1}
  # to eliminate, look to constants to keep conventions consistent.

  # Disable STI
  self.inheritance_column = :__disabled

  scope :in_reverse_chron_order, -> { order('end_datetime DESC') }
  scope :with_bids, -> { includes(:bids) }
end
