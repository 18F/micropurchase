Feature: Guest with token views unpublished auction
  As an authorized partner
  I should be able to preview an unpublished auction using a token
  So I can check that the text and other details are correct

  Scenario: Guest with token views an auction
    Given there is an unpublished auction
    And I visit the admin auction page with the token
    Then I should see the auction title
    And I should see the unpublished auction message for guests
