Feature: Small Business Vendors
  As an adminstrator
  I want to be able to identify small-business users
  So they can bid on restricted auctions

  Scenario: I see whether a user (with a DUNS number, in Sam.gov) is a small business
    Given I am an administrator
    And there are various types of users in the system
    When I sign in
    And I visit the admin users page
    Then I should see a column labeled "Small Business?"
    # Figuring out to best make this in a Gherkin environment
    # And for each user who has a DUNS nSam.gov that is a small business, I should see "Yes"
    # And for each user who has a DUNS number and is in Sam.gov that is not a small business, I should see "No"
    # And for each user who does not both have a DUNS number and is in Sam.gov, I should see "N/A"
