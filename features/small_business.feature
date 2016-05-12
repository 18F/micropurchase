Feature: Small Business Vendors
  As an adminstrator
  I want to be able to identify small-business users
  So they can bid on restricted auctions

  Scenario: A user that is not a small business
    Given I am an administrator
    And there is a user in SAM.gov who is not a small business
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "No" for the user in the "Small Business?" column

  Scenario: A user who is a small business
    Given I am an administrator
    And there is a user in SAM.gov who is a small business
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "Yes" for the user in the "Small Business?" column

  Scenario: A user who is not in SAM.gov
    Given I am an administrator
    And there is a user who is not in SAM.gov
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    And I should see "N/A" for the user in the "Small Business?" column
