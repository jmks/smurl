When /^I create a custom url$/ do
  @vanity_url = 'roflcopter'
  @url = 'http://en.wiktionary.org/wiki/roflcopter'

  fill_in 'url',    with: @url
  fill_in 'vanity', with: @vanity_url

  click_button 'smurlify'
end

Then /^I should see that url$/ do
  expect(page).to have_content ('/' + @vanity_url)
end