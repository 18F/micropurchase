FactoryGirl.define do
  sequence(:github_id) { |n| n }
  sequence(:duns_number) { |n| "1234567#{n}" }

  factory :user do
    duns_number
    name { Faker::Name.name }
    email { Faker::Internet.email }
    github_id 123_456
    sam_account true
    credit_card_form_url 'https://some-website.com/pay'

    factory :admin_user do
      github_id { Admins.github_ids.first }
    end
  end
end
