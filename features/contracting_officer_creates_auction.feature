Feature: Contracting Officers
  As an admin and contracting officer
  I should be able to create auctions over $3500

  Scenario: contracting office creates auction over $3500
    Given I am a contracting officer
    And there is a client account to bill to
    And I sign in
    When I visit the auctions admin page
    And I click on the "Create a new auction" link
    And I edit the new auction form
    And I set the auction start price to $24000
    And I click to create an auction
    Then I should see that my auction was created successfully
    When I click to edit the auction
    Then I should see the start price for the auction is $24000
