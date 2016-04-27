Then(/^email notifications are sent to losing bidders$/) do
  LosingBidderEmailSender.new(@auction).perform
end

Then(/^I should receive an email notifying me that I did not win$/) do
  Delayed::Worker.new.work_off
  email = ActionMailer::Base.deliveries.first
  expect(email.to.first).to eq @user.email
  expect(email.body.encoded).to include(
    I18n.t('mailers.auction_mailer.losing_bidder_notification.para_2')
  )
end
