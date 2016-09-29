Feature: Admin views future auction
  As an admin of the Micro-purchase system
  I want to be able to unpublish future auctions

  Scenario: Viewing the auction page
    Given I am an administrator
    And I sign in
    And there is a future auction
    When I visit the auction page
    Then I should see a "Coming Soon" label
    And I should not see the bid form
    And I should see the future published auction message for admins

    When I click on the unpublish button
    Then I should see a success message confirming that the auction was updated

  Scenario: Viewing the admin auction page
    Given I am an administrator
    And I sign in
    And there is a future auction
    When I visit the admin auction page for that auction
    Then I should see the future published auction message for admins

    When I click on the unpublish button
    Then I should see a success message confirming that the auction was updated
    And I should see the auction as an unpublished auction that is ready to be published

  Scenario: Viewing the admin auction page for an auction that uses a non-default purchase card
    Given I am an administrator
    And I sign in
    And there is a future auction
    And the auction is for a different purchase card
    When I visit the admin auction page for that auction
    Then I should see the future published auction message for admins

    When I click on the unpublish button
    Then I should see a success message confirming that the auction was updated
    And I should see the auction as an unpublished auction that is ready to be published
