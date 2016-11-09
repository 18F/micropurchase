Feature: Admin can mark a delivery missed for an auction
  As an administrator
  I should be able to mark an auction as not delivered
  So that we can keep track of auctions that were not delivered

 Scenario: Admin sees a way to mark an auction as not delivered
   Given I am an administrator
   And I sign in
   And there is an auction with work in progress
   And the delivery deadline for that auction has passed
   When I visit the admin auction page for that auction
   Then I should see the admin status for an auction with overdue delivery
   And I should see a "Mark as not delivered" button

   When I click on the "Mark as not delivered" button
   And I should see the admin status for an auction with missed delivery
