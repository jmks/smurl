Feature: Url shortening service
  In order to post urls on twitter and blogs with brevity
  As an internet user
  I want to shorten urls

Scenario: Create a shortened url
  Given I am on the home page
  When I provide a url to shorten
  Then I should see the shortened url