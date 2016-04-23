FactoryGirl.define do
  factory :auction do
    start_datetime { Time.now - 3.days }
    end_datetime { Time.now + 3.days }
    delivery_url { nil }
    awardee_paid_status { :not_paid }
    result { :not_applicable }
    title { Faker::Company.catch_phrase }
    summary { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraphs(3, true).join("\n\n") }
    issue_url 'https://github.com/18F/calc/issues/255'
    github_repo 'https://github.com/18F/calc'
    notes 'The auction went well!'
    billable_to 'Tock'
    cap_proposal_url { nil }
    published { :published }
    type { :multi_bid }

    trait :single_bid_with_tie do
      single_bid

      after(:create) do |auction|
        Timecop.freeze(auction.start_datetime) do
          Timecop.scale(3600)
          2.times do
            FactoryGirl.create(:bid, auction: auction, amount: 3000)
          end
        end
      end
    end

    trait :with_bidders do
      transient do
        bidder_ids []
      end

      after(:build) do |instance|
        Timecop.freeze(instance.start_datetime) do
          Timecop.scale(3600)
          (1..2).each do |i|
            amount = 3499 - (20 * i) - rand(10)
            instance.bids << FactoryGirl.create(:bid, auction: instance, amount: amount)
          end
        end
      end

      after(:create) do |auction, evaluator|
        evaluator.bidder_ids.each_with_index do |bidder_id, index|
          lowest_bid = auction.bids.sort_by(&:amount).first
          amount = lowest_bid.amount - (10 * index) - rand(10)
          auction.bids << FactoryGirl.create(:bid, bidder_id: bidder_id, auction: auction, amount: amount)
        end
      end
    end

    trait :available do
      start_datetime { Time.now - 2.days }
      end_datetime { Time.now + 2.days }
    end

    trait :closed do
      end_datetime { Time.now - 2.days }
    end

    trait :delivered do
      closed
      delivery_url { 'https://github.com/foo/bar' }
    end

    trait :not_delivered do
      delivery_url { nil }
    end

    trait :paid do
      delivered
      awardee_paid_status { :paid }
    end

    trait :running do
      with_bidders
    end

    trait :expiring do
      end_datetime { Time.now + 3.hours }
    end

    trait :future do
      start_datetime { Time.now + 1.day }
    end

    trait :delivery_deadline_expired do
      closed
      delivery_deadline { end_datetime + 1.day }
    end

    trait :accepted do
      result { :accepted }
    end

    trait :rejected do
      result { :rejected }
    end

    trait :paid do
      awardee_paid_status { :paid }
    end

    trait :not_paid do
      awardee_paid_status { :not_paid }
    end

    trait :cap_submitted do
      cap_proposal_url { 'https://cap.18f.gov/proposals/2486' }
    end

    trait :not_evaluated do
      result { :not_applicable }
    end

    trait :published do
      published { :published }
    end

    trait :unpublished do
      published { :unpublished }
    end

    trait :single_bid do
      type { :single_bid }
    end

    trait :multi_bid do
      type { :multi_bid }
    end

    trait :complete_and_successful do
      with_bidders
      delivery_deadline_expired
      delivered
      accepted
      cap_submitted
      paid
    end

    trait :payment_pending do
      delivery_deadline_expired
      delivered
      accepted
      cap_submitted
      not_paid
    end

    trait :payment_needed do
      delivery_deadline_expired
      delivered
      accepted
    end

    trait :evaluation_needed do
      delivery_deadline_expired
      delivered
      not_evaluated
    end

    trait :delivery_past_due do
      delivery_deadline_expired
      not_delivered
    end
  end
end
