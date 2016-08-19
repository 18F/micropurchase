Feature: Admin views closed auction
  As an administrator
  I want to be able to view a closed auction

  Scenario: Auction is paid, winning vendor has not yet confirmed payment
    Given I am an administrator
    And I sign in
    And there is a complete and successful auction
    And the auction was marked as paid in C2
    When I visit the admin auction page for that auction
    Then I should see the C2 status for an auction pending payment confirmation

  Scenario: Auction is paid, winning vendor has confirmed payment
    Given I am an administrator
    And I sign in
    And there is a complete and successful auction
    And the vendor confirmed payment
    When I visit the admin auction page for that auction
    Then I should see the C2 status for an auction with payment confirmation
