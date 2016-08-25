Feature: Admin views payment receipt
  As an admin
  I want to see receipts for payments
  So that I know the vendor received their money

  Scenario: Admin visits the receipt url
    Given I am an administrator
    And I sign in
    And there is a payment confirmed auction
    And I visit the auction receipt page
    Then I should see when the winning vendor was paid in ET
    And I should see the auction's description
    And I should see the auction's c2_status
    And I should see the winning bid amount
    And I should see the winning bidder name
    And I should see the winning bidder email
