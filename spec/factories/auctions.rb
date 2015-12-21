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
        (1..4).each do |i|
          amount = 3499 - (20 * i) - rand(10)
          instance.bids << FactoryGirl.create(:bid, auction: instance, amount: amount)
        end
      end
    end
    
    factory :current_auction do
      with_bidders
    end

    factory :closed_auction do
      end_datetime { Time.now - 1.day }
      with_bidders
    end

    factory :running_auction do
      end_datetime { Time.now + 1.day }
      with_bidders
    end
  end
end
