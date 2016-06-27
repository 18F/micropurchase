Feature: Admin downloads auction data
  As an admin of the Micro-purchase system
  I should be able to download data about auctions
  So I can do analysis on them

  Scenario: I get a CSV file containing Sam.gov data for the winning vendor
    Given I am an administrator
    And I sign in
    And there is a closed auction
    And the winning bidder has a valid DUNS number
    When I visit the admin auction page for that auction
    And I click on the link to generate a winning bidder CSV report
    Then the file should contain the following data from Sam.gov:
      """
      13GG Vendor Name,
      13JJ Vendor Address Line 1,
      13KK Vendor Address Line 2,
      13LL Vendor Address Line 3,
      13MM Vendor Address City,
      13NN Vendor Address State,
      13PP Vendor Zip Code,
      13QQ Vendor Country Code,
      13RR Vendor Phone Number,
      13SS Vendor Fax Number,
      2B Effective Date,
      2C Current Completion Date,
      3A Base And All Options Value,
      3B Base And Exercised Options Value,
      3C Action Obligation,
      6M Description of Requirement,
      6N Purchase Card as Payment Method,
      6R National Interest Action,
      9A DUNS Number,
      9B Contractor Name from Contract,
      10J Commercial Item Test Program,
      10M Solicitation Procedures,
      Sudol, Brendan,
      4301 N Henderson Rd Apt 408,
      Arlington,
      VA,
      222032511,
      USA,
      5404218332,
      Y,
      None,
      N,
      SP1
      """
