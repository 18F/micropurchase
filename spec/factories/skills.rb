FactoryGirl.define do
  sequence(:name) { |n| "skill #{n}" }

  factory :skill do
    name
  end
end
