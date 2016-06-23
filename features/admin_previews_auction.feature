Feature: Admin previews auctions
  As an admin of the Micropurchase system
  I want to be able to preview unpublished auctions
  So that I will be able to more efficiently work with the system

  Scenario: Previewing an unpublished auction
    Given I am an administrator
    And I sign in
    And there is also an unpublished auction
    When I visit the preview page for the unpublished auction
    Then I should see a preview of the auction
