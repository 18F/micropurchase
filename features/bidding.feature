Feature: Bidding
  As a contractor
  I want to be able to bid on auctions
  So I can be paid for work

  Scenario: Logging in to place a bid
    Given there is an open auction
    And I am a user with a verified SAM account
    When I visit the home page
    Then I expect to see the auction title
    And I expect to see a current bid amount

    When I click on the auction title
    Then I expect to be on the auction page
    And I expect to see a link to the auction issue URL
    And there should be meta tags for the open auction

    When I visit the home page
    And I click on the "View details »" link
    Then I expect to see a link to the auction issue URL

    When I click on the "BID »" button
    Then I expect to see an "Authorize with GitHub »" button

    When I click on the "Authorize with GitHub »" link
    Then I expect to be on the profile edit page
    And I click on the Submit button
    Then I expect to see the auction title

    When I click on the "Bid »" button
    Then I expect to see a current bid amount

    When I submit a bid for $800
    Then I expect to see a confirmation for $800

    When I click on the Confirm button
    Then I expect to see a current bid amount of $800

  Scenario: Logging in before bidding
    Given there is an open auction
    And I am a user with a verified SAM account
    And I sign in and verify my account information
    When I click on the "Bid »" button
    Then I expect to not see an Authorize With Github button
    And I expect to see a current bid amount

    When I submit a bid for $999
    Then I expect to see a confirmation for $999
    
    When I click on the Confirm button
    Then I expect to see a current bid amount of $999
    And I expect to see I have the winning bid

  Scenario: Viewing an auction when I have not bid
    Given there is an open bidless auction
    And I am allowed to bid
    When I visit the home page
    And I click on the Bid button

    Then I expect to be on the new bid page
    And I expect to not see an Authorize With Github button
    And I expect to see a message about no bids

  Scenario: When someone else has outbid me
    Given there is an open auction
    And I am allowed to bid
    When I visit the home page
    And I click on the Bid button
    
    Then I expect to not see an Authorize With Github button
    And I expect to be on the new bid page
    And I expect to see a current bid amount
    And I expect to see I do not have the winning bid
