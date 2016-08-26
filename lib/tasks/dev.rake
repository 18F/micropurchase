if Rails.env.development?
  require "factory_girl"
  require Rails.root.join('spec', 'support', 'helpers', 'factory_girl.rb')

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryGirl::Syntax::Methods

      skills = [
        Skill.find_or_create_by(name: 'rails'),
        Skill.find_or_create_by(name: 'golang'),
        Skill.find_or_create_by(name: 'react'),
        Skill.find_or_create_by(name: 'rust'),
        Skill.find_or_create_by(name: 'elm'),
        Skill.find_or_create_by(name: 'a-language-you-never-heard-of')
      ]

      FactoryGirl.create(:auction, :reverse, :pending_c2_approval)
      FactoryGirl.create(:auction, :reverse, :with_bidders)
      FactoryGirl.create(:auction, :reverse, :expiring, :with_bidders)
      future_reverse = FactoryGirl.create(:auction, :reverse, :future)
      future_reverse.skills << skills
      FactoryGirl.create(:auction, :reverse, :closed, :with_bidders, purchase_card: :other)
      FactoryGirl.create(:auction, :sealed_bid, :with_bidders)
      FactoryGirl.create(:auction, :sealed_bid, :expiring, :with_bidders)
      future_sealed = FactoryGirl.create(:auction, :sealed_bid, :future)
      future_sealed.skills << skills
      FactoryGirl.create(:auction, :complete_and_successful)
      FactoryGirl.create(:auction, :payment_needed)
      FactoryGirl.create(:auction, :evaluation_needed)
      FactoryGirl.create(:auction, :unpublished)
      FactoryGirl.create(:auction, :rejected, :with_bidders)
    end
  end
end
