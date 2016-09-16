Feature: Admin views missing Payment URL
  As an administrator
  I should be able to see if an auction is missing a payment URL
  So I can ask the vendor to provide one

  Scenario: Admin sees message in status box for auction that payment URL is needed before payment can be made
    Given I am an administrator
    And I sign in
    And there is an accepted auction where the winning vendor is missing a payment method
    When I visit the admin auction page for that auction
    Then I should see an admin status message that the vendor needs to provide a payment URL
    And I should see a link to the delivery URL

  Scenario: Admin sees status in the "Needs Payment" section of needs attention page that a payment URL is needed
    Given I am an administrator
    And I sign in
    And there is an accepted auction where the winning vendor is missing a payment method
    And I visit the Needs Attention page
    Then I should see a table listing all payment needed auctions
    And I should see the auction as a payment needed auction
    And I should see "Needs Credit Card URL"
