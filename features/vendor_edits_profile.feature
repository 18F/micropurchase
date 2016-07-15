Feature: Vendor edits profile
  As a vendor
  I should be able to edit my profile
  So that it is accurate

  Scenario: User views and edits their information
    Given I am a user with a verified SAM account
    And I am signed in
    When I visit my profile page
    Then I should be on my profile page
    And I should see a profile form with my info

    When I fill the "Email address" field with "doris@example.com"
    When I fill the "Name" field with "Doris Doogooder"
    And I click on the "Update" button
    Then I should be on the home page

    When I click on the "My profile" link
    Then I should see "doris@example.com" in the "Email address" field
    And I should see "Doris Doogooder" in the "Name" field

    When I click on the "Logout" link
    And I click on the "Sign in" link

    When I visit my profile page
    Then I should see "doris@example.com" in the "Email address" field
    And I should see "Doris Doogooder" in the "Name" field

  Scenario: User without a DUNS number views and edits their information
    Given I am a user without a DUNS number
    And I am signed in
    And I visit my profile page

    When I should be on my profile page
    And I should see a profile form with my info

    When I fill the "Email address" field with "doris@example.com"
    When I fill the "Name" field with "Doris Doogooder"
    And I click on the "Update" button
    Then I should be on the home page

  Scenario: User tries to enter an invalid email address
    Given I am a user with a verified SAM account
    And I am signed in
    When I visit my profile page
    Then I should be on my profile page
    And I should see a profile form with my info

    When I fill the "Email address" field with "doris_the_nonvalid_email_address_person"
    And I click on the "Update" button
    Then I should see an alert that "Email is invalid"

    When I visit the home page
    And I click on the "My profile" link
    Then I should see my email in the "Email address" field
