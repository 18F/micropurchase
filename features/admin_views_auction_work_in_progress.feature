Feature: Admin views work in progress auction
  As an administrator
  I want to see that an auction is a work in progress
  So I can know what the delivery URL is

  Scenario: Viewing a work in progress auction on its admin show page
    Given I am an administrator
    And I am signed in
    And there is an auction with work in progress
    When I visit the admin auction page for that auction
    Then I should see the work in progress status box for admins
