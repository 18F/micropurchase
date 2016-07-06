Feature: Admin associates customer with auction
  As an administrator
  I want to be able to associate auctions with customers
  So that users and admins can see who is creating certain projects

  Scenario: Associating an auction with a customer
    Given I am an administrator
    And I sign in
    And there is an open auction
    And there is a customer
    And I visit the auctions admin page
    
    When I click to edit the auction
    Then I should see a select box with all the customers in the system
    
    When I select a customer on the form
    And I click on the "Update" button
    Then I expect the customer to have been saved

    When I click to edit the auction
    Then I should see the customer selected for the auction

  Scenario: Seeing the customer on the auction page
    Given I am an administrator
    And I sign in
    And there is an auction with an associated customer
    When I visit the auction page
    Then I should see the customer name on the page

    When I visit the admin auction page for that auction
    Then I should see the customer name on the page

  Scenario: Vendor sees the customer
    Given I am a user with a verified SAM account
    And I sign in
    And there is an auction with an associated customer
    When I visit the auction page
    Then I should see the customer name on the page

  Scenario: Do not display the customer label if not set
    Given I am a user with a verified SAM account
    And I sign in
    And there is an open auction
    When I visit the auction page
    Then I should not see a label for the customer on the page
