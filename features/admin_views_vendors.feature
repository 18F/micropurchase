Feature: Admin views venedors
  As an administrator
  I want to be able to see information about vendors
  So that I can see how many users we have

  Scenario: visiting the admin vendors page
    Given I am an administrator
    And I sign in
    And I click on the "People" link
    When I click on the "Vendors" link
    Then I should be on the admin vendors page
    Then I will not see a warning I must be an admin

  Scenario: A vendor that is not a small business
    Given I am an administrator
    And there is a user in SAM.gov who is not a small business
    When I sign in
    When I visit the admin vendors page
    Then I should see a column labeled "Small business"
    And I should see "No" for the user in the "Small business" column

  Scenario: A vendor who is a small business
    Given I am an administrator
    And there is a user in SAM.gov who is a small business
    When I sign in
    When I visit the admin vendors page
    Then I should see a column labeled "Small business"
    And I should see "Yes" for the user in the "Small business" column

  Scenario: A user who is not in SAM.gov
    Given I am an administrator
    And there is a user who is not in SAM.gov
    When I sign in
    When I visit the admin vendors page
    Then I should see a column labeled "Small business"
    And I should see "N/A" for the user in the "Small business" column
