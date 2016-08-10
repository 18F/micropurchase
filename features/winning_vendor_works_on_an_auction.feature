Feature: Winning vendor works on an auction
  As a vendor
  I want to be able to work on an auction
  So that I can deliver my work

  Scenario: Vendor submits valid delivery URL
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    When I visit the auction page
    And I submit a delivery URL
    Then I should see the work in progress status box

  Scenario: Vendor submits blank delivery URL
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    When I visit the auction page
    And I submit a blank delivery URL
    Then I should see the ready for work status box
    And I should see the error message for an empty delivery URL

  Scenario: Vendor marks work as done
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    When I visit the auction page
    And I submit a delivery URL
    And I click on the I'm done button
    Then I should see the pending acceptance status box
