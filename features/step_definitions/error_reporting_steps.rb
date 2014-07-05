When /^I enter an empty url$/ do
  visit '/'

  click_button 'smurlify'
end

def submit_small_url url, vanity
  visit '/'

  fill_in 'url', with: url
  fill_in 'vanity', with: vanity

  click_button 'smurlify'
end

Then /^I should see an empty url error message$/ do
  expect(page).to have_content "Url cannot be empty"
end

When /^I enter an invalid custom url$/ do
  submit_small_url 'http://www.llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch.com', 'omg-too-long'
end

Then /^I should see a custom url error message$/ do
  expect(page).to have_content "Custom url can only contain"
end

When /^I enter an existing custom url$/ do
  @slashdot = SmallUrl.get_small_url 'www.slashdot.org', 'sd'

  submit_small_url @slashdot.url, 'sd' # TODO: design failure
end

Then /^I should see a duplication error message$/ do
  expect(page.text).to match /Custom name '[a-zA-Z0-9]+' already exists/
end