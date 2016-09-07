Feature: Admin views future unpublished auctions
  As an an administrator
  I should be able to view future auctions
  So I can unpublish them if there any any problems

  Scenario:
    Given I am an administrator
    And I sign in
    And there is a future auction

    When I visit the admin auction page for that auction
    Then I should see the coming soon status box for admins

    When I click on the unpublish button
    Then I should be on the Needs Attention page
    And I should see the auction as a draft auction
