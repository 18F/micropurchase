class Auction < ActiveRecord::Base
  MAX_START_PRICE = 3500

  belongs_to :user
  include ActiveModel::SerializerSupport
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

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

  delegate(
    :auction_rules_href,
    :formatted_type,
    :highlighted_bid,
    :highlighted_bid_label,
    :max_allowed_bid,
    :partial_path,
    :show_bids?,
    :user_can_bid?,
    :veiled_bids,
    :winning_bid,
    to: :auction_rules
  )

  delegate(
    :future?,
    :expiring?,
    :over?,
    :available?,
    to: :auction_status
  )

  delegate(
    :label,
    :label_class,
    :status_text,
    :tag_data_label_2,
    :tag_data_value_status,
    :tag_data_value_2,
    to: :status_presenter
  )

  def user_bid_amount_as_currency(user)
    if bids.where(bidder: user).any?
      number_to_currency(bids.where(bidder: user).order(amount: :asc).first.amount)
    end
  end

  def index_bid_summary_partial
    auction_rules.partial_path('index_bid_summary')
  end

  def highlighted_bid_info_partial
    auction_rules.partial_path('highlighted_bid_info', 'bids')
  end

  def show_bid_button?(user)
    user.nil? || user_can_bid?(user)
  end

  def user_can_bid?(user)
    auction_rules.user_can_bid?(user)
  end

  def user_is_bidder?(user)
    bids.where(bidder: user).any?
  end

  def user_is_winning_bidder?(user)
    bids.any? && user == winning_bid.bidder
  end

  def highlighted_bid_amount_as_currency(user = nil)
    number_to_currency(highlighted_bid_amount(user))
  end

  def highlighted_bid_amount(user)
    highlighted_bid(user).try(:amount)
  end

  def highlighted_bidder_name(user)
    highlighted_bid(user).bidder.name
  end

  def highlighted_bid(user)
    auction_rules.highlighted_bid(user)
  end

  def lowest_bid
    lowest_bids.first
  end

  def lowest_bids
    bids.select { |b| b.amount == lowest_amount }.sort_by(&:created_at)
  end

  def lowest_bid_amount
    lowest_bid.nil? ? nil : lowest_bid.amount
  end

  def delivery_deadline_expires_in
    time_in_human(delivery_deadline)
  end

  def human_start_time
    time_in_human(start_datetime)
  end

  def html_description
    if description.present?
      markdown.render(description)
    else
      ""
    end
  end

  def html_summary
    if summary.present?
      markdown.render(summary)
    else
      ""
    end
  end

  def starts_at
    DcTimePresenter.convert_and_format(start_datetime)
  end

  def ends_at
    DcTimePresenter.convert_and_format(end_datetime)
  end

  def status_presenter_class
    status_name = if expiring?
                    'Expiring'
                  elsif over?
                    'Over'
                  elsif future?
                    'Future'
                  else
                    'Open'
                  end
    "::AuctionStatus::#{status_name}ViewModel".constantize
  end

  def status_presenter
    @status_presenter ||= status_presenter_class.new(self)
  end

  private

  def lowest_amount
    bids.sort_by(&:amount).first.try(:amount)
  end

  def start_price_equal_to_or_less_than_max_if_not_contracting_officer
    if user && !user.contracting_officer? && start_price > MAX_START_PRICE
      errors.add(
        :start_price,
        I18n.t(
          'activerecord.errors.models.auction.attributes.start_price.invalid',
          start_price: MAX_START_PRICE
        )
      )
    end
  end

  def auction_rules
    @auction_rules ||= RulesFactory.new(self).create
  end

  def auction_status
    AuctionStatus.new(self)
  end

  def time_in_human(time)
    distance = distance_of_time_in_words(Time.now, time)
    if time < Time.now
      "#{distance} ago"
    else
      "in #{distance}"
    end
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      lax_spacing: true
    )
  end
end
