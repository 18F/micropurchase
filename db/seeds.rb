require Rails.root.join('spec', 'support', 'helpers', 'factory_girl.rb')

skills = FactoryGirl.create_list(:skill, 2)
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
FactoryGirl.create(:auction, :delivery_past_due)
FactoryGirl.create(:auction, :unpublished)
rejected_auction = FactoryGirl.create(:auction, :sealed_bid, :closed, :with_bidders)
rejected_auction.skills << skills
