Feature: Vendor edits profile
  As a vendor
  I should be able to edit my profile
  So that it is accurate

  Scenario: User views and edits their information
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    And I visit my profile page
    Then I should be on my profile page
    And I should see a profile form with my info
    And there should be meta tags for the edit profile form

    When I fill the "Email Address" field with "doris@example.com"
    When I fill the "Name" field with "Doris Doogooder"
    And I click on the "Submit" button
    Then I should be on the home page

    When I click on the "Edit profile" link
    Then I should see "doris@example.com" in the "Email Address" field
    And I should see "Doris Doogooder" in the "Name" field

    When I click on the "Logout" button
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    And I visit my profile page
    And I should see "doris@example.com" in the "Email Address" field
    And I should see "Doris Doogooder" in the "Name" field

  Scenario: User without a DUNS number views and edits their information
    Given I am a user without a DUNS number
    When I visit the home page
    And I click on the "Login" button
    And I click on the "Authorize with GitHub" button
    And I visit my profile page

    When I should be on my profile page
    And I should see a profile form with my info
    And there should be meta tags for the edit profile form

    When I fill the "Email Address" field with "doris@example.com"
    When I fill the "Name" field with "Doris Doogooder"
    And I click on the "Submit" button
    Then I should be on the home page

  Scenario: User tries to enter an invalid email address
    Given I am a user with a verified SAM account
    When I visit the home page
    And I click on the "Login" button
    Then I should see an "Authorize with GitHub" button

    When I click on the "Authorize with GitHub" button
    And I visit my profile page
    Then I should be on my profile page
    And I should see a profile form with my info

    When I fill the "Email Address" field with "doris_the_nonvalid_email_address_person"
    And I click on the "Submit" button
    Then I should see an alert that "Email is invalid"

    When I visit the home page
    And I click on the "Edit profile" button
    Then I should see my email in the "Email Address" field
