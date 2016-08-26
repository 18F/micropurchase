Feature: Winning vendor confirms payment
  As a vendor
  I want to be able to confirm payment
  So 18F knows more about the auction status

  Scenario: Winning vendor visits receipt page
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    And the auction is paid
    When I visit the new auction receipt page
    Then I should be on the auction receipt page
    And I should see the payment confirmation needed message

  Scenario: Winning vendor visit receipts page when logged out
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    And the auction is paid
    And I click on the "Logout" link
    When I visit the new auction receipt page
    And I click on the "Authorize with GitHub" button
    Then I should be on the auction receipt page

  @background_jobs_off
  Scenario: Winning vendor confirms payment
    Given I am an authenticated vendor
    And I am going to win an auction
    And the auction ends
    And the auction is accepted
    And the auction is paid
    When I visit the new auction receipt page
    And I click on the confirm received payment button
    Then I should see the payment confirmed message
    And the payment receipt should be sent to C2
