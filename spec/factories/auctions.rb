FactoryGirl.define do
  factory :auction do
    start_datetime { Time.now - 3.days }
    end_datetime { Time.now + 3.days }
    title 'Oh no, fix the world'
    description 'it is broken!'
    issue_url 'https://github.com/18F/calc/issues/255'
    github_repo 'https://github.com/18F/calc'

    trait :with_bidders do
      after(:build) do |instance|
        Timecop.freeze(instance.start_datetime) do
          Timecop.scale(3600)
          (1..4).each do |i|
            amount = 3499 - (20 * i) - rand(10)
            instance.bids << FactoryGirl.create(:bid, auction: instance, amount: amount)
          end
        end
      end
    end

    trait :closed do
      end_datetime { Time.now - 1.day }
    end

    trait :running do
      with_bidders
    end

    trait :future do
      start_datetime { Time.now + 1.day }
    end
  end
end
