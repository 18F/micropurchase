FactoryGirl.define do
  sequence :github_id do |n|
    n
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    duns_number { Faker::Company.duns_number }
    github_id 123_456
    sam_account true

    factory :admin_user do
      github_id { Admins.github_ids.first }
    end

    trait :with_duns_not_in_sam do
      duns_number { Faker::Company.duns_number }
    end

    trait :with_duns_in_sam do
      duns_number { '130477032' }
    end
  end
end
