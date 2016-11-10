Feature: Admin views closed auctions in the admin panel
  As an admin of the Micro-purchase system
  I want to be able to view successful and rejected closed auctions

  Scenario: There are no closed auctions
    Given I am an administrator
    And I sign in
    When I visit the admin closed auctions page
    Then I should see "No auctions have been rejected yet"
    And I should see "No auctions have been successfully delivered yet"
    And I should see "There are no auctions that have not been delivered"

  Scenario: Viewing closed successful auctions
    Given I am an administrator
    And there is a complete and successful auction
    And I sign in
    When I visit the admin closed auctions page
    Then I should see the name of the auction

  Scenario: Viewing closed rejected auctions
    Given I am an administrator
    And there is a rejected auction
    And I sign in
    When I visit the admin closed auctions page
    Then I should see the name of the auction
    And I should see the edit link for the auction

  Scenario: Admin sees data for auctions that weren't delivered
    Given I am an administrator
    And I sign in
    And there is an auction with work in progress
    And the delivery deadline for that auction has passed
    And the auction has been marked as missing delivery
    When I visit the admin closed auctions page
    Then I should see a table listing all missed delivery auctions
    And I should see the auction as a missed delivery auction
