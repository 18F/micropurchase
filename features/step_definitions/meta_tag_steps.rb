Then(/^there should be meta tags for the edit profile form$/) do
  expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - Edit user: #{@user.name}")
end

Then(/^there should be meta tags for the closed auction$/) do
  pr_auction = AuctionPresenter.new(@auction)

  expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - #{pr_auction.title}")
  expect(page).to have_css("meta[property='og:title'][content='18F Micro-purchase - #{pr_auction.title}']", visible: false)
end

Then(/^there should be meta tags for the open auction$/) do
  pr_auction = AuctionPresenter.new(@auction)

  expect(page).to have_css("title", visible: false, text: "18F Micro-purchase - #{pr_auction.title}")
  expect(page).to have_css("meta[property='og:title'][content='18F Micro-purchase - #{pr_auction.title}']", visible: false)
end

# FIXME
Then(/^there should be meta tags for the index page for (\d+) open and (\d+) future auctions$/) do |open_count, future_count|
  expect(page).to have_css("title", visible: false, text: "18F - Micro-purchase")
  expect(page).to have_css("meta[property='og:title'][content='18F - Micro-purchase']", visible: false)
  expect(page).to have_css("meta[name='description'][content='The Micro-purchase Marketplace is the place to bid on open-source issues from the 18F team.']", visible: false)
  expect(page).to have_css("meta[property='og:description'][content='The Micro-purchase Marketplace is the place to bid on open-source issues from the 18F team.']", visible: false)
  expect(page).to have_css("meta[name='twitter:label1'][value='Active Auctions']", visible: false)
  expect(page).to have_css("meta[name='twitter:data1'][value='#{open_count}']", visible: false)
  expect(page).to have_css("meta[name='twitter:label2'][value='Coming Auctions']", visible: false)
  expect(page).to have_css("meta[name='twitter:data2'][value='#{future_count}']", visible: false)
end
