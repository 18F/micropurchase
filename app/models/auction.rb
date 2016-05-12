class Auction < ActiveRecord::Base
  MICROPURCHASE_THRESHOLD = 3500

  belongs_to :user
  has_many :bids
  has_many :bidders, through: :bids
  enum result: { not_applicable: 0, accepted: 1, rejected: 2 }
  enum type: { single_bid: 0, multi_bid: 1 }
  enum awardee_paid_status: { not_paid: 0, paid: 1 }
  enum published: { unpublished: 0, published: 1 }

  # Disable STI
  self.inheritance_column = :__disabled

  validates :end_datetime, presence: true
  validates :start_datetime, presence: true
  validates :user, presence: true
  validate :start_price_equal_to_or_less_than_max_if_not_contracting_officer

  def lowest_bid
    lowest_bids.first
  end

  def lowest_bids
    bids.select { |b| b.amount == lowest_amount }.sort_by(&:created_at)
  end

  private

  def lowest_amount
    bids.sort_by(&:amount).first.try(:amount)
  end

  def start_price_equal_to_or_less_than_max_if_not_contracting_officer
    if user && !user.contracting_officer? && start_price > MICROPURCHASE_THRESHOLD
      errors.add(
        :start_price,
        I18n.t(
          'activerecord.errors.models.auction.attributes.start_price.invalid',
          start_price: MICROPURCHASE_THRESHOLD
        )
      )
    end
  end
end
