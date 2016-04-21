Feature: Credit Card Form URL
  As a vendor on the platform
  I want to see the Credit Card Form URL stored for my account
  So that I can make sure payments are going to the right place

  Scenario: Vendor views Credit Card Form URL
    Given I am an authenticated vendor
    And there is a Credit Card Form URL associated with my account
    When I visit my profile page
    Then I should see my credit card form URL in the "Credit Card Form URL" field

  Scenario: Vendor saves a payment URL
    Given I am an authenticated vendor
    And there is no Credit Card Form URL associated with my account
    When I visit my profile page
    And I fill in the Credit Card Form URL field on my profile page
    And I click on the "Submit" button
    Then I should be on the home page

    When I visit my profile page
    Then I should see my credit card form URL in the "Credit Card Form URL" field

  Scenario: Vendor edits an existing Payment URL
    Given I am an authenticated vendor
    And there is a Credit Card Form URL associated with my account
    And I visit my profile page
    When I fill in the Credit Card Form URL field on my profile page
    And I click on the "Submit" button
    Then I should be on the home page

    When I visit my profile page
    Then the new value should be stored as my Credit Card Form URL

  Scenario: Vendor cannot save credit card URL with invalid format
    Given I am an authenticated vendor
    And there is no Credit Card Form URL associated with my account
    And I visit my profile page
    When I fill in the Credit Card Form URL field on my profile page with "htt:/bad.url\\"
    And I click on the "Submit" button
    Then I should see "Credit card form url is not a valid URL"
    And my Credit Card Form URL should not be set
