FactoryGirl.define do
  factory :client_account do
    sequence(:name) { |n| "Client Account #{n}" }
    billable true
    sequence(:tock_id) { |n| n }
  end
end
