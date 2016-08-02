Feature: Admin edits auctions in the admins panel
  As an admin
  I should be able to modify existing auctions

  Scenario: Updating an auction
    Given I am an administrator
    And I sign in
    And there is an open auction
    And there is a client account to bill to
    And there is a skill in the system
    And I visit the auctions admin page

    When I click to edit the auction
    Then I should see the current auction attributes in the form
    And I should be able to edit the existing auction form

    When I click on the "Update" button
    Then I should be on the admin auctions page
    And I expect my auction changes to have been saved

    When I click on the auction's title
    Then I should see the start time I set for the auction
    And I should see the end time I set for the auction
    And I should see new content on the page

  Scenario: Associating an auction with a customer
    Given I am an administrator
    And I sign in
    And there is an open auction
    And there is a customer

    When I visit the admin form for that auction
    Then I should see a select box with all the customers in the system

    When I select a customer on the form
    And I click on the "Update" button
    Then I expect the customer to have been saved

    When I click to edit the auction
    Then I should see the customer selected for the auction

  @javascript
  Scenario: Associating an auction with a skill
    Given I am an administrator
    And I sign in
    And there is an open auction
    And there is a skill in the system
    When I visit the admin form for that auction
    And I select a skill on the form
    And I click on the "Update" button
    And I click to edit the auction
    Then I should see the skill that I set for the auction selected

  Scenario: Marking accepted auction as paid
    Given I am an administrator
    And I sign in
    And there is an accepted auction
    And the auction is for a different purchase card
    When I visit the admin form for that auction
    And I check the "Paid" checkbox
    And I click on the "Update" button
    Then I should see when the winning vendor was paid in ET

  Scenario: Accepted auction already marked as paid
    Given I am an administrator
    And I sign in
    And there is a paid auction
    And the auction is for a different purchase card
    When I visit the admin form for that auction
    Then I should see the disabled "Paid" checkbox

  Scenario: Marking non-accepted auction as paid
    Given I am an administrator
    And I sign in
    And there is an auction that needs evaluation
    And the auction is for a different purchase card
    When I visit the admin form for that auction
    Then I should not see the "Paid" checkbox
