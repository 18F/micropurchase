Feature: Admin views available auction
  As an administrator
  I want to see a sidebar status for available auctions
  So I can see what the progress of them is

  Scenario: The auction has no bids yet
    Given I am an administrator
    And I sign in
    And there is a budget approved auction with no bids

    When I visit the auction page
    Then I should see an admin status message that the auction is available with no bids

    When I visit the admin auction page for that auction
    Then I should see an admin status message that the auction is available with no bids


  Scenario: The auction has bids
    Given I am an administrator
    And I sign in
    And there is a budget approved auction with bids

    When I visit the auction page
    Then I should see an admin status message that the auction is available with bids

    When I visit the admin auction page for that auction
    Then I should see an admin status message that the auction is available with bids
