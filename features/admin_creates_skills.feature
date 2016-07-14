Feature: Admin creates skills in the admins panel
  As an admin
  I should be able to create skills

  Scenario: Adding a skill
    Given I am an administrator
    When I sign in
    And I visit the skills admin page
    And I click on the "Add skill" link
    And I fill the "skill_name" field with "baking"
    And I click on the "Create Skill" button
    Then I should be on the skills admin page
    And I should see "baking" in the list of skills

  Scenario: Skill is invalid
    Given I am an administrator
    And there is a skill for "baking" already
    When I sign in
    And I visit the skills admin page
    And I click on the "Add skill" link
    And I fill the "skill_name" field with "baking"
    And I click on the "Create Skill" button
    Then I should see an error that "Name has already been taken"
