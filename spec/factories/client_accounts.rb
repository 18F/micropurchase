FactoryGirl.define do
  factory :client_account do
    name { "#{Faker::Company.profession.capitalize} Pension Benefit Guaranty Corporation" }
    billable true
    sequence(:tock_id) {|n| n}
  end
end
