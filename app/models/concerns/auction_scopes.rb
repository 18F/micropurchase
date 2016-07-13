module AuctionScopes
  extend ActiveSupport::Concern

  included do
    scope :accepted, -> { where(result: results['accepted']) }
    scope :c2_not_submitted, -> { where(c2_proposal_url: [nil, '']) }
    scope :c2_submitted, -> { where.not(c2_proposal_url: [nil, '']) }
    scope :closed_within_last_24_hours, -> { where(ended_at: last_24_hours..next_24_hours) }
    scope :delivered, -> { where.not(delivery_url: [nil, '']) }
    scope :delivery_due_at_expired, -> { where('delivery_due_at < ?', Time.current) }
    scope :ended_at_in_future, -> { where('ended_at > ?', Time.current) }
    scope :evaluated, -> { where(result: [results['accepted'], results['rejected']]) }
    scope :in_reverse_chron_order, -> { order('ended_at DESC') }
    scope :not_delivered, -> { where(delivery_url: [nil, '']) }
    scope :not_evaluated, -> { where(result: [nil, results['not_applicable']]) }
    scope :not_paid, -> { where(paid_at: nil) }
    scope :paid, -> { where.not(paid_at: nil) }
    scope :published, -> { where(published: publishes['published']) }
    scope :started_at_in_future, -> { where('started_at > ?', Time.current) }
    scope :started_at_in_past, -> { where('started_at < ?', Time.current) }
    scope :unpublished, -> { where(published: [nil, '', publisheds['unpublished']]) }
    scope :with_bids, -> { includes(:bids) }
    scope :with_bids_and_bidders, -> { includes(:bids, :bidders) }

    def self.today
      Time.current.to_date
    end

    def self.last_24_hours
      today - 24.hours
    end

    def self.next_24_hours
      today + 24.hours
    end
  end
end
