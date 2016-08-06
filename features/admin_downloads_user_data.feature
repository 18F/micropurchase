Feature: Admin downloads user data
  As an admin of the Micro-purchase system
  I should be able to download information about all users
  So I can do analysis or send emails to them

  Scenario: A link on the users page
    Given I am an administrator
    And I sign in
    When I visit the admin vendors page
    Then I should see a Download CSV link

  Scenario: Downloading a CSV from the users page
    Given I am an administrator
    And I sign in

    Given there is a user in SAM.gov who is a small business
    When I visit the admin vendors page
    And I click on the Download CSV link
    Then I should receive a CSV file
    And the file should contain non-admin user data
