FactoryGirl.define do
  sequence(:github_id) { |n| n }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :user do
    duns_number { Faker::Company.duns_number }
    name { Faker::Name.name }
    email
    github_id 123_456
    github_login 'github_username'
    sam_status :duns_blank
    credit_card_form_url 'https://some-website.com/pay'

    trait :sam_accepted do
      sam_status :sam_accepted
    end

    trait :small_business do
      duns_number { FakeSamApi::SMALL_BUSINESS_DUNS }
      sam_status { :sam_accepted }
      small_business { true }
    end

    trait :not_small_business do
      duns_number { FakeSamApi::BIG_BUSINESS_DUNS }
      sam_status { :sam_accepted }
      small_business { false }
    end

    trait :with_bid do
      after(:create) do |user|
        create(:bid, bidder: user)
      end
    end

    factory :admin_user do
      github_id { Admins.github_ids.first }

      factory :contracting_officer do
        contracting_officer true
      end
    end
  end
end
