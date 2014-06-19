Feature: Vanity Urls
  In order to stand out from other tweeters
  As a twitter fiend
  I want to have customized shortened urls

Scenario: Create custom urls
  Given I am on the home page
  When I create a custom url
  Then I should see that url