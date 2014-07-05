When /^I provide a url to shorten$/ do
  @long_url = 'http://www.toolongfor140charactersorless.com'
  submit_small_url @long_url
end

Then /^I should see the shortened url$/ do
  @small_url = SmallUrl.get_small_url(@long_url)

  expect(page).to have_content @small_url.small_url
end