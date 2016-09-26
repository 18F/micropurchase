Feature: Admin publishes auction in the admin panel
  As an admin
  I should be able to publish auctions

  Scenario: Auction is C2 budget approved and uses default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    And the c2 proposal for the auction is budget approved
    When I visit the admin auction page for that auction
    And I click on the Publish button
    Then I should see the future published auction message for admins

  Scenario: Auction is not C2 budget approved and uses default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    And the c2 proposal for the auction is not budget approved
    When I visit the admin auction page for that auction
    Then I should see that the C2 status for an auction pending C2 approval

  Scenario: Auction does not use default purchase card
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for a different purchase card
    When I visit the admin auction page for that auction
    And I click on the Publish button
    Then I should see the future published auction message for admins
