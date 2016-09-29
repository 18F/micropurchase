require 'factory_girl'
require Rails.root.join('spec', 'support', 'helpers', 'factory_girl.rb')

namespace :dev do
  desc 'Sample data for local development environment'
  task prime: 'db:setup' do
    include FactoryGirl::Syntax::Methods

    skills = [
      Skill.find_or_create_by(name: 'rails'),
      Skill.find_or_create_by(name: 'golang'),
      Skill.find_or_create_by(name: 'react'),
      Skill.find_or_create_by(name: 'rust'),
      Skill.find_or_create_by(name: 'elm'),
      Skill.find_or_create_by(name: 'a-language-you-never-heard-of')
    ]

    create(:client_account, active: true)
    create(:client_account, active: false)

    FactoryGirl.create(:auction, :reverse, :pending_c2_approval)
    FactoryGirl.create(:auction, :reverse, :with_bids)
    FactoryGirl.create(:auction, :reverse, :expiring, :with_bids)
    future_reverse = FactoryGirl.create(:auction, :reverse, :future)
    future_reverse.skills << skills
    FactoryGirl.create(:auction, :reverse, :closed, :with_bids, purchase_card: :other)
    FactoryGirl.create(:auction, :reverse, :closed, :with_bids, :c2_budget_approved, :delivery_url)
    FactoryGirl.create(:auction, :sealed_bid, :with_bids)
    FactoryGirl.create(:auction, :sealed_bid, :expiring, :with_bids)
    future_sealed = FactoryGirl.create(:auction, :sealed_bid, :future)
    future_sealed.skills << skills
    FactoryGirl.create(:auction, :complete_and_successful)
    FactoryGirl.create(:auction, :payment_needed)
    FactoryGirl.create(:auction, :evaluation_needed)
    FactoryGirl.create(:auction, :unpublished)
    FactoryGirl.create(:auction, :rejected, :with_bids)
  end
end
