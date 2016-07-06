Feature: Admin publishes auction in the admin panel
  As an admin
  I should be able to publish auctions

  Scenario: Auction is C2 approved and uses default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    And the c2 proposal for the auction is approved
    When I visit the admin form for that auction
    Then I should be able to set the auction to published

  Scenario: Auction is not C2 approved and uses default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    And the c2 proposal for the auction is not approved
    When I visit the admin form for that auction
    Then I should not be able to set the auction to published

  Scenario: Auction does not use default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for a different purchase card
    When I visit the admin form for that auction
    Then I should be able to set the auction to published
