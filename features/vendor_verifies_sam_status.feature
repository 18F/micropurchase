Feature: Automatically checking a user's SAM status
  As a user looking to bid on an auction
  I want the Micro-purchase site to automatically check my SAM status
  So that I do not need to wait for manual reconciliation to bid

  Scenario: Successful SAM check on login
    Given I am a user without a verified SAM account
    And a SAM check for my DUNS will return true
    When I sign in and verify my account information
    Then I should become a valid SAM user

    When there is an open auction
    And I visit the auction page
    Then I should see a success message that "Your DUNS number has been verified in Sam.gov"

    When I visit my profile page
    Then I should see that my DUNS number was verified

  Scenario: Successful SAM check on DUNS edit
    Given I am a user without a verified SAM account
    And I am signed in
    And a SAM check for my DUNS will return true
    When I visit my profile page
    And I enter a valid DUNS in my profile
    And I click on the "Update" button
    Then I should become a valid SAM user
    When I visit my profile page
    Then I should see that my DUNS number was verified
    When I visit the home page
    Then I should see a success message that "Your DUNS number has been verified in Sam.gov"

  @background_jobs_off
  Scenario: Pending SAM check on DUNS edit
    Given I am a user without a verified SAM account
    And I am signed in
    When I visit my profile page
    And I enter a new DUNS in my profile
    And I click on the "Update" button
    Then I should see a warning that "Your profile is pending while your DUNS number is being validated. This typically takes less than one hour"
    When I visit my profile page
    Then I should see that my DUNS number is being verified

  Scenario: Negative SAM check on login
    Given I am a user without a verified SAM account
    When I sign in and verify my account information
    Then I should see an alert that my DUNS number was not found in Sam.gov
    When I visit my profile page
    Then I should see that my DUNS number was not verified

  Scenario: Negative SAM check on DUNS change
    Given I am a user without a verified SAM account
    And I am signed in
    When I visit my profile page
    And I enter an invalid DUNS in my profile
    And I click on the "Update" button
    Then I should not become a valid SAM user
    And I should see an alert that my DUNS number was not found in Sam.gov
    When I visit my profile page
    Then I should see that my DUNS number was not verified

  Scenario: No DUNS number present
    Given I am a user without a DUNS number
    And I am signed in
    And there is an open auction
    When I visit the home page
    Then I should not see an alert

    When I click on the auction's title
    Then I should see a warning that "In order to bid, you must supply a valid DUNS number. Please update your profile"


  Scenario: Admin user
    Given I am an administrator
    And I am signed in
    When I visit the home page
    Then I should not see a flash message
