Feature: logging in and out
  As a vendor
  I should be able to log into the application
  So that I can bid on auctions

  Scenario: User logs in and clicks the edit profile link
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the Login button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should see an "Edit profile" button

    When I click on the "Edit profile" button
    Then I should see a profile form with my info
    And there should be meta tags for the edit profile form

  Scenario: New user logs in, created and logs out via header link
    Given I only have a Github account
    When I visit the home page
    And I click on the Login button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should see the name from github authentication
    And I should see a "Logout" button

    When I fill out the profile form
    And I click on the "Submit" button
    Then I should be on the home page
    And I should see my changes

    When I click on the "Logout" button
    Then I should not see my name
    And I should see a "Login" button

  Scenario: Existing user logs in
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the Login button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should see my name
    And I should see a "Logout" button
    
  Scenario: User logs in when viewing protected or specific information
    Given I am a user with a verified SAM account
    When I visit my bids page
    Then I should see an "Authorize with GitHub" button
    
    When I click on the "Authorize with GitHub" button
    Then I should see my name
    And I should see a "Logout" button

  Scenario: User views and edits their information
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should be on my profile page
    And I should see a profile form with my info
    And there should be meta tags for the edit profile form

    When I fill the "Email Address" field with "doris@doogooder.com"
    When I fill the "Name" field with "Doris Doogooder"
    And I click on the "Submit" button
    Then I should be on the home page
    
    When I click on the "Edit profile" link
    Then I should see "doris@doogooder.com" in the "Email Address" field
    And I should see "Doris Doogooder" in the "Name" field

    When I click on the "Logout" button
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should be on my profile page
    And I should see "doris@doogooder.com" in the "Email Address" field
    And I should see "Doris Doogooder" in the "Name" field
    
  Scenario: User tries to enter an invalid email address
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    Then I should be on my profile page
    And I should see a profile form with my info
    

    When I fill the "Email Address" field with "doris_the_nonvalid_email_address_person"
    And I click on the "Submit" button
    Then I should see an alert that "Email is invalid"

    When I visit the home page
    And I click on the "Edit profile" button
    Then I should see my email in the "Email Address" field
