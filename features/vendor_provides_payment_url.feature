Feature: Vendor updates Payment URL
  As a vendor on the platform
  I want to see the Payment URL stored for my account
  So that I can make sure payments are going to the right place

  Scenario: Vendor views Payment URL
    Given I am an authenticated vendor
    And there is a Payment URL associated with my account
    When I visit my profile page
    Then I should see my payment url in the "Payment url" field

  Scenario: Vendor saves a payment URL
    Given I am an authenticated vendor
    And there is no Payment URL associated with my account
    When I visit my profile page
    And I fill in the Payment URL field on my profile page
    And I click on the "Update" button
    Then I should be on the home page

    When I visit my profile page
    Then I should see my payment URL in the "Payment url" field

  Scenario: Vendor edits an existing Payment URL
    Given I am an authenticated vendor
    And there is a Payment URL associated with my account
    And I visit my profile page
    When I fill in the Payment URL field on my profile page
    And I click on the "Update" button
    Then I should be on the home page

    When I visit my profile page
    Then the new value should be stored as my Payment URL

  Scenario: Vendor cannot save payment URL with invalid format
    Given I am an authenticated vendor
    And there is no Payment URL associated with my account
    And I visit my profile page
    When I fill in the Payment URL field on my profile page with "htt:/bad.url\\"
    And I click on the "Update" button
    Then I should see "Payment url is not a valid URL"
    And my Payment URL should not be set

  Scenario: Vendor is winning bidder and updates payment url
    Given there is an accepted auction where the winning vendor is missing a payment method
    And I am the winning bidder
    And I sign in
    When I visit the auction page
    Then I should see the auction missing payment method status box

    When I visit my profile page
    And I fill in the Payment URL field on my profile page
    And I click on the "Update" button
    And I visit the auction page
    Then I should see that the auction was accepted
