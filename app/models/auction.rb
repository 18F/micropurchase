class Auction < ActiveRecord::Base
  include AuctionScopes
  C2_REGEX = Regexp.escape("#{ENV['C2_HOST']}/proposals/").freeze

  attr_accessor :due_in_days

  belongs_to :user
  belongs_to :customer
  has_many :bids
  has_many :bidders, through: :bids
  has_and_belongs_to_many :skills

  enum result: { not_applicable: 0, accepted: 1, rejected: 2, pending_acceptance: 3 }
  enum type: { sealed_bid: 0, reverse: 1 }
  enum published: { unpublished: 0, published: 1 }
  enum purchase_card: { default: 0, other: 1 }
  enum c2_approval_status: { not_requested: 0, pending: 1, pending_approval: 2, approved: 3 }

  # Disable STI
  self.inheritance_column = :__disabled

  validate :user_is_contracting_officer_if_above_micropurchase
  validates :delivery_due_at, presence: true, if: :published?
  validates :description, presence: true, if: :published?
  validates :ended_at, presence: true
  validates :purchase_card, presence: true
  validates :start_price, presence: true
  validates :started_at, presence: true
  validates :summary, presence: true, if: :published?
  validates :title, presence: true
  validates :user, presence: true
  validates :billable_to, presence: true
  validates(
    :c2_proposal_url,
    format: { with: Regexp.new("#{C2_REGEX}[0-9]") },
    allow_blank: true
  )

  def sorted_skill_names
    skills.order(name: :asc).map(&:name)
  end

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

  def user_is_contracting_officer_if_above_micropurchase
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
