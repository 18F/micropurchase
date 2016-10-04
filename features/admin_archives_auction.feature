Feature: Admin archives auction
  As an admin
  I should be able to archive unpublished auctions
  So they will not be listed anymore

  Scenario: Admin can archive unpublished auction that is not yet approved
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    And the c2 proposal for the auction is not budget approved
    When I visit the admin form for that auction
    Then I should see the Archive button

  Scenario: Admin can archive unpublished auction that is approved
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    When I visit the admin form for that auction
    Then I should see the Archive button

  Scenario: Admin can not archive published auction
    Given I am an administrator
    And I sign in
    And there is an open auction
    And the auction is for the default purchase card
    When I visit the admin form for that auction
    Then I should not see the Archive button

  @javascript
  Scenario: When the user clicks the link
    Given I am an administrator
    And I sign in
    And there is an unpublished auction
    And the auction is for the default purchase card
    When I visit the admin form for that auction

    When I click on the Archive button
    When I click OK on the javascript confirm dialog to archive the auction
    Then I should see the admin status message for an archived auction

    When I visit the Needs Attention page
    Then I should not see the auction as a draft auction

    When I visit the admin closed auctions page
    Then I should see the auction as an archived auction
