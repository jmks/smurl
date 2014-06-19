Feature: Error messages
  In order to gain feedback
  As a user
  I want to see error messages

Scenario: Empty url
  When I enter an empty url
  Then I should see an empty url error message

Scenario: Invalid custom url
  When I enter an invalid custom url
  Then I should see a custom url error message