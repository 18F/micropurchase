Feature: Admin views draft auctions in the admin panel
  As an admin of the Micro-purchase system
  I want to be able to view auction drafts

  Scenario: Admin sees data for draft auctions on the Needs Attention page
    Given there is an unpublished auction
    Given I am an administrator
    And I sign in
    Then I should be on the Needs Attention page
    When I click on the draft auctions link
    Then I should see a table listing all draft auctions
    And I should see the auction title
