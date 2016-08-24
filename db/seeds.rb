require Rails.root.join('spec', 'support', 'helpers', 'factory_girl.rb')

skills = [
  Skill.find_or_create_by(name: 'rails'),
  Skill.find_or_create_by(name: 'golang'),
  Skill.find_or_create_by(name: 'react'),
  Skill.find_or_create_by(name: 'rust'),
  Skill.find_or_create_by(name: 'elm'),
  Skill.find_or_create_by(name: 'a-language-you-never-heard-of')
]
FactoryGirl.create(:auction, :reverse, :with_bidders)
FactoryGirl.create(:auction, :reverse, :expiring, :with_bidders)
FactoryGirl.create(:auction, :reverse, :future)
FactoryGirl.create(:auction, :reverse, :closed, :with_bidders)
FactoryGirl.create(:auction, :sealed_bid, :with_bidders)
FactoryGirl.create(:auction, :sealed_bid, :expiring, :with_bidders)
FactoryGirl.create(:auction, :sealed_bid, :future)
auction = FactoryGirl.create(:auction, :sealed_bid, :closed, :with_bidders)
auction.skills << skills
FactoryGirl.create(:auction, :complete_and_successful)
FactoryGirl.create(:auction, :payment_needed)
FactoryGirl.create(:auction, :evaluation_needed)
FactoryGirl.create(:auction, :unpublished)
rejected_auction = FactoryGirl.create(:auction, :sealed_bid, :closed, :with_bidders)
rejected_auction.skills << skills
