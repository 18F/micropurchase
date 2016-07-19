FactoryGirl.define do
  factory :auction do
    association :user, factory: :admin_user
    billable_to "Project (billable)"
    started_at { TimeHelpers::quartile_minute(Time.now - 3.days) }
    ended_at { TimeHelpers::quartile_minute(Time.now + 3.days) }
    result :not_applicable
    title { Faker::Company.catch_phrase }
    type :reverse
    published :published
    summary Faker::Lorem.paragraph
    description Faker::Lorem.paragraphs(3, true).join("\n\n")
    delivery_due_at { TimeHelpers::quartile_minute(Time.now + 10.days) }
    purchase_card :default

    trait :sealed_bid_with_tie do
      sealed_bid

      after(:create) do |auction|
        Timecop.freeze(auction.started_at) do
          Timecop.scale(3600)
          2.times do
            create(:bid, auction: auction, amount: 3000)
          end
        end
      end
    end

    trait :winning_vendor_is_small_business do
      after(:create) do |auction|
        create(:bid, :from_small_business, auction: auction)
      end
    end

    trait :winning_vendor_is_non_small_business do
      after(:create) do |auction|
        create(:bid, :from_non_small_business, auction: auction)
      end
    end

    trait :with_bidders do
      published
      transient do
        bidder_ids []
      end

      after(:build) do |instance|
        Timecop.freeze(instance.started_at) do
          Timecop.scale(3600)
          (1..2).each do |i|
            amount = 3499 - (20 * i) - rand(10)
            instance.bids << create(:bid, auction: instance, amount: amount)
          end
        end
      end

      after(:create) do |auction, evaluator|
        evaluator.bidder_ids.each_with_index do |bidder_id, index|
          lowest_bid = auction.bids.sort_by(&:amount).first
          amount = lowest_bid.amount - (10 * index) - rand(10)
          auction.bids << create(:bid, bidder_id: bidder_id, auction: auction, amount: amount)
        end
      end
    end

    trait :between_micropurchase_and_sat_threshold do
      association :user, factory: :contracting_officer
      start_price do
        rand(AuctionThreshold::MICROPURCHASE+1..AuctionThreshold::SAT)
      end
    end

    trait :below_micropurchase_threshold do
      start_price { rand(1..AuctionThreshold::MICROPURCHASE) }
    end

    trait :available do
      started_at { TimeHelpers::quartile_minute(Time.now - 2.days) }
      ended_at { TimeHelpers::quartile_minute(Time.now + 2.days) }
    end

    trait :closed do
      ended_at { TimeHelpers::quartile_minute(Time.now - 2.days) }
    end

    trait :delivered do
      ended_at { TimeHelpers::quartile_minute(Time.now - 2.days) }
      delivery_due_at { TimeHelpers::quartile_minute(Time.now - 1.day) }
      delivery_url 'https://github.com/foo/bar'
    end

    trait :not_delivered do
      delivery_url nil
    end

    trait :paid do
      delivered
      paid_at { Time.current }
    end

    trait :running do
      with_bidders
    end

    trait :expiring do
      ended_at { TimeHelpers::quartile_minute(Time.now + 3.hours) }
    end

    trait :future do
      started_at { TimeHelpers::quartile_minute(Time.now + 1.day) }
    end

    trait :delivery_due_at_expired do
      closed
      delivery_due_at { TimeHelpers::quartile_minute(ended_at + 1.day) }
    end

    trait :accepted do
      result :accepted
      accepted_at { Time.now }
    end

    trait :rejected do
      result :rejected
      rejected_at { Time.now }
    end

    trait :not_paid do
      paid_at nil
    end

    trait :c2_approved do
      c2_proposal_url 'https://c2-dev.18f.gov/proposals/2486'
      c2_approved_at { Time.current }
    end

    trait :not_evaluated do
      result :not_applicable
    end

    trait :published do
      published :published
    end

    trait :unpublished do
      published :unpublished
    end

    trait :sealed_bid do
      type :sealed_bid
    end

    trait :reverse do
      type :reverse
    end

    trait :completed do
      published
      delivery_due_at_expired
    end

    trait :complete_and_successful do
      with_bidders
      delivery_due_at_expired
      delivered
      accepted
      c2_approved
      paid
    end

    trait :payment_needed do
      delivery_due_at_expired
      accepted
      delivered
      c2_approved
      not_paid
    end

    trait :evaluation_needed do
      delivered
      not_evaluated
      delivery_due_at_expired
    end

    trait :delivery_past_due do
      not_delivered
      delivery_due_at_expired
    end
  end
end
