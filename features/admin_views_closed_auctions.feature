Feature: Admin views closed auctions in the admin panel
  As an admin of the Micro-purchase system
  I want to be able to view successful and rejected closed auctions

  Scenario: Viewing closed successful auctions
    Given I am an administrator
    And there is a complete and successful auction
    And I sign in
    When I visit the admin closed auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction
    And I should see "No auctions have been rejected yet"

  Scenario: Viewing closed rejected auctions
    Given I am an administrator
    And there is a rejected auction
    And I sign in
    When I visit the admin closed auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction
    And I should see "No auctions have been successfully delivered yet"

