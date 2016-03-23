Feature: Automatically checking a user's SAM status
  As a user looking to bid on an auction
  I want the Micropurchase site to automatically check my SAM status
  So that I do not need to wait for manual reconciliation to bid

  Scenario: Successful SAM check on login
    Given I am a user without a verified SAM account
    And a SAM check for my DUNS will return true
    When I sign in and verify my account information
    Then I should become a valid SAM user
    And I should not see a warning about my SAM registration

  Scenario: Successful SAM check on DUNS edit
    Given I am a user without a verified SAM account
    And I am signed in
    And a SAM check for my DUNS will return true
    When I enter a new DUNS in my profile
    And I click on the "Submit" button
    Then I should become a valid SAM user
    And I should not see a warning about my SAM registration

  Scenario: Exception during SAM check on login
    Given I am a user without a verified SAM account
    And a SAM check for my DUNS will raise an exception
    When I sign in and verify my account information
    Then I should not become a valid SAM user
    And I should see a warning that my SAM registration is not complete
      
  Scenario: Negative SAM check on login
    Given I am a user without a verified SAM account
    And a SAM check for my DUNS will return false
    When I sign in and verify my account information
    Then I should not become a valid SAM user
    And I should see a warning that my SAM registration is not complete

  Scenario: Exception during SAM check on DUNS change
    Given I am a user without a verified SAM account
    And I am signed in
    And a SAM check for my DUNS will raise an exception
    When I enter a new DUNS in my profile
    And I click on the "Submit" button
    Then I should not become a valid SAM user
    And I should see a warning that my SAM registration is not complete
      
  Scenario: Negative SAM check on DUNS change
    Given I am a user without a verified SAM account
    And I am signed in
    And a SAM check for my DUNS will return false
    When I enter a new DUNS in my profile
    And I click on the "Submit" button
    Then I should not become a valid SAM user
    And I should see a warning that my SAM registration is not complete

