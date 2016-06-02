class Auction < ActiveRecord::Base
  attr_accessor :due_in_days

  belongs_to :user
  has_many :bids
  has_many :bidders, through: :bids
  enum result: { not_applicable: 0, accepted: 1, rejected: 2 }
  enum type: { single_bid: 0, multi_bid: 1 }
  enum awardee_paid_status: { not_paid: 0, paid: 1 }
  enum published: { unpublished: 0, published: 1 }

  # Disable STI
  self.inheritance_column = :__disabled

  validates :ended_at, presence: true
  validates :started_at, presence: true
  validates :start_price, presence: true
  validates :title, presence: true
  validates :user, presence: true
  validate :start_price_equal_to_or_less_than_max_if_not_contracting_officer
  validates :summary, presence: true, if: :published?
  validates :description, presence: true, if: :published?
  validates :delivery_due_at, presence: true, if: :published?

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
    if user && !user.contracting_officer? && start_price > AuctionThreshold::MICROPURCHASE
      errors.add(
        :start_price,
        I18n.t(
          'activerecord.errors.models.auction.attributes.start_price.invalid',
          start_price: AuctionThreshold::MICROPURCHASE
        )
      )
    end
  end
end
