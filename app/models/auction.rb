class Auction < ActiveRecord::Base
  include AuctionScopes
  C2_REGEX = Regexp.escape("#{ENV['C2_HOST']}/proposals/").freeze

  attr_accessor :due_in_days

  belongs_to :user
  belongs_to :customer
  has_many :bids
  has_many :bidders, through: :bids
  has_and_belongs_to_many :skills

  has_secure_token

  enum c2_status: {
    not_requested: 0,
    sent: 2,
    pending_approval: 1,
    budget_approved: 3,
    c2_paid: 4,
    payment_confirmed: 5
  }

  enum delivery_status: {
    pending_delivery: 0,
    work_in_progress: 5,
    pending_acceptance: 3,
    accepted_pending_payment_url: 4,
    accepted: 1,
    rejected: 2
  }

  enum published: { unpublished: 0, published: 1, archived: 2 }
  enum purchase_card: { default: 0, other: 1 }
  enum type: { sealed_bid: 0, reverse: 1 }

  # Disable STI
  self.inheritance_column = :__disabled

  validate :user_is_contracting_officer_if_above_micropurchase
  validates :delivery_due_at, presence: true
  validates :ended_at, presence: true
  validates :purchase_card, presence: true
  validates :start_price, presence: true
  validates :started_at, presence: true
  validates :title, presence: true
  validates :user, presence: true
  validates :billable_to, presence: true
  validates(
    :c2_proposal_url,
    format: { with: Regexp.new("#{C2_REGEX}[0-9]") },
    allow_blank: true
  )

  validates :summary, presence: true, if: :published?
  validates :description, presence: true, if: :published?
  validates_with PublishedAuctionValidator, on: :update, if: :published_changed?

  def sorted_skill_names
    skills.order(name: :asc).map(&:name)
  end

  def lowest_bid
    lowest_bids.first
  end

  private

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

  def lowest_bids
    bids.select { |b| b.amount == lowest_amount }.sort_by(&:created_at)
  end

  def lowest_amount
    bids.sort_by(&:amount).first.try(:amount)
  end
end
