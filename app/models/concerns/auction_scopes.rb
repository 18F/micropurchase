module AuctionScopes
  extend ActiveSupport::Concern

  included do
    scope :accepted, -> { where(delivery_status: delivery_statuses['accepted']) }
    scope :accepted_pending_payment_url, lambda {
      where(delivery_status: delivery_statuses['accepted_pending_payment_url'])
    }
    scope :accepted_or_accepted_and_pending_payment_url, lambda {
      where(delivery_status: [delivery_statuses['accepted'],
                              delivery_statuses['accepted_pending_payment_url']])
    }
    scope :default_purchase_card, -> { where(purchase_card: 0) }
    scope :delivery_url, -> { where.not(delivery_url: [nil, '']) }
    scope :ended_at_in_future, -> { where('ended_at > ?', Time.current) }
    scope :ended, -> { where('ended_at < ?', Time.current) }
    scope :evaluated, -> { where(delivery_status: [delivery_statuses['accepted'], delivery_statuses['rejected']]) }
    scope :in_reverse_chron_order, -> { order('ended_at DESC') }
    scope :pending_acceptance, -> { where(delivery_status: delivery_statuses['pending_acceptance']) }
    scope :pending_delivery, -> { where(delivery_status: delivery_statuses['pending_delivery']) }
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
