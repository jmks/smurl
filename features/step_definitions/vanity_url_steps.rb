When /^I create a custom url$/ do
  @vanity_url = 'roflcopter'
  @url = 'http://en.wiktionary.org/wiki/roflcopter'

  submit_small_url @url, @vanity_url
end

Then /^I should see that url$/ do
  # TODO: this is a workaround that doesn't
  # check the new url was created
  # => need better db cleaning
  visit '/urls'
  expect(page).to have_content ('/' + @vanity_url)
end