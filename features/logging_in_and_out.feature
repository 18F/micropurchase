Feature: logging in and out
  As a vendor
  I should be able to log into the application
  So that I can bid on auctions

  Scenario: User logs in and clicks the edit profile link
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the Login button
    Then I expect to see an "Authorize with GitHub" button
    
    When I click on the "Authorize with GitHub" button
    Then I expect to see an "Edit profile" button

    When I click on the "Edit profile" button
    Then I expect to see a profile form with my info
    And there should be meta tags for the edit profile form

  Scenario: New user logs in, created and logs out via header link
    Given I only have a Github account
    When I visit the home page
    And I click on the Login button
    Then I expect to see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I expect to see the name from github authentication
    And I expect to see a "Logout" button

    When I fill out the profile form
    And I click on the "Submit" button
    Then I expect to be on the home page
    And I expect to see my changes

    When I click on the "Logout" button
    Then I expect to not see my name
    And I expect to see a "Login" button

  Scenario: Existing user logs in
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the Login button
    Then I expect to see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I expect to see my name
    And I expect to see a "Logout" button
    
  Scenario: User logs in when viewing protected or specific information
    Given I am a user with a verified SAM account
    When I visit my bids page
    Then I expect to see an "Authorize with GitHub" button
    
    When I click on the "Authorize with GitHub" button
    Then I expect to see my name
    And I expect to see a "Logout" button

  Scenario: User views and edits their information
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I expect to see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I expect to be on the profile edit page
    And I expect to see a profile form with my info
    And there should be meta tags for the edit profile form

    When I fill the "Email Address" field with "doris@doogooder.com"
    And I click on the "Submit" button
    Then I expect to be on the home page
    
    When I click on the "Edit profile" link
    Then I expect to see "doris@doogooder.com" in the "Email Address" field

  Scenario: User tries to enter an invalid email address
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I expect to see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I expect to be on the profile edit page
    And I expect to see a profile form with my info
    And there should be meta tags for the edit profile form

    When I fill the "Email Address" field with "doris_the_nonvalid_email_address_person"
    And I click on the "Submit" button
    Then I expect to see an alert that "Email is invalid"

    When I visit the home page
    And I click on the "Edit profile" button
    Then I expect to see my email in the "Email Address" field
