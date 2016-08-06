Feature: Admin Edits Customers
  As an admin user
  I want to have an automated way to keep track of which customer agency is sponsoring which auction.
  So the system should give me a way to store this information.

  Background:
    Given I am an administrator
    And I sign in

  Scenario: Admin sees a new customer agency form
    When I visit the admin customers page
    And I click on the add customer button
    Then I should see an "Agency name" text field
    And I should see a "Contact name" text field
    And I should see an "Email" text field

  Scenario: I save a client without specifying a name
    When I visit the admin customers page
    And I click on the add customer button
    And I click on the create customer button
    Then the customer should not be created
    And I should be on the new admin customer form
    And I should see an error that the agency name can't be blank

  Scenario: I successfully create a new Customer
    When I visit the admin customers page
    And I click on the add customer button
    And I fill in values for a new customer
    And I click on the create customer button
    Then the customer should be created
    And I should be on the admin customers page
    And I should see a success message that the customer was created successfully
    And I should see the new customer on the page

