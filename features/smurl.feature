Feature: Url shortening service
  In order to post urls on twitter and blogs with brevity
  As an internet user
  I want to shorten urls

Scenario: Create a shortened url
  Given I am on the home page
  When I provide a url to shorten
  Then I should see the shortened url

Scenario: CustomUrl links already in use
  Given the next small url's encoded id is used by a custom url
  When I create a new small url without vanity url
  And when I visit the new small url link
  Then I should be redirected to the new url

Scenario: Some custom urls can not be used
  Given a list of blacklisted custom urls
  When I create a new small url with a blacklisted custom url
  Then I should see an error message