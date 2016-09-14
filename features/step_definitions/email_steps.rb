Then(/^email notifications are sent to losing bidders$/) do
  LosingBidderEmailSender.new(@auction).perform
end

Then(/^an email notification is sent to the winning bidder$/) do
  WinningBidderEmailSender.new(@auction).perform
end

Then(/^I should not receive an email notifying me that I won$/) do
  Delayed::Worker.new.work_off
  emails = ActionMailer::Base.deliveries
  expect(emails).to be_empty
end

Then(/^I should not receive an email notifying me that I did not win$/) do
  Delayed::Worker.new.work_off
  emails = ActionMailer::Base.deliveries
  expect(emails).to be_empty
end

Then(/^the vendor should receive an email notifying them that the work was rejected$/) do
  winner = WinningBid.new(@auction).find.bidder
  email = ActionMailer::Base.deliveries.last

  expect(email.to.first).to eq winner.email
  expect(email.body.encoded).to include(
    I18n.t(
      'mailers.winning_bidder_mailer.auction_rejected.para_1',
      issue_url: @auction.issue_url,
      auction_title: @auction.title,
      rejected_at: DcTimePresenter.convert_and_format(@auction.reload.rejected_at)
    )
  )
end

Then(/^I should receive an email notifying me that I did not win$/) do
  emails = ActionMailer::Base.deliveries
  email = emails.find { |sent_email| sent_email.to.include? @user.email }

  expect(email.to.first).to eq @user.email
  expect(email.body.encoded).to include(
    I18n.t('mailers.auction_mailer.losing_bidder_notification.para_2')
  )
end

Then(/^I should receive an email notifying me that I won$/) do
  email = ActionMailer::Base.deliveries.first
  expect(email.to.first).to eq @user.email
  expect(email.body.encoded).to include(
    I18n.t(
      'mailers.auction_mailer.winning_bidder_notification.para_2',
      auction_url: ""
    )
  )
end

Then(/^the vendor should receive an email requesting payment information$/) do
  email = ActionMailer::Base.deliveries.last
  expect(email.to.first).to eq @winning_bidder.email
  winning_bid = WinningBid.new(@auction).find
  expect(email.body.encoded).to include(
    I18n.t(
      'mailers.winning_bidder_mailer.auction_accepted_missing_payment_method.para_1',
      accepted_date: DcTimePresenter.convert_and_format(@auction.accepted_at),
      auction_title: @auction.title,
      amount: Currency.new(winning_bid.amount).to_s,
      profile_url: profile_url
    )
  )
end
