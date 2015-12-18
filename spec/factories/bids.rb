FactoryGirl.define do
  factory :bid do
    association :bidder, factory: :user
    association :auction
  end
end
