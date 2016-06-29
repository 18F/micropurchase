FactoryGirl.define do
  factory :customer do
    agency_name "Federal Bureau of Unit Testing"
    contact_name { Faker::Name.name }
    email
  end
end
