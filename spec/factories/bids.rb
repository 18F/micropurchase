FactoryGirl.define do
  factory :bid do
    association :bidder, factory: :user
    association :auction

    trait :from_small_business do
      association :bidder, factory: [:user, :small_business]
    end

    trait :from_non_small_business do
      association :bidder, factory: [:user, :not_small_business]
    end
  end
end
