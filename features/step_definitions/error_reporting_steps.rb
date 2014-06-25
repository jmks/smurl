git When /^I enter an empty url$/ do
  visit '/'

  click_button 'smurlify'
end

Then /^I should see an empty url error message$/ do
  expect(page).to have_content "Url cannot be empty"
end

When /^I enter an invalid custom url$/ do
  visit '/'

  fill_in 'url', with: 'http://www.llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch.com'
  fill_in 'vanity', with: 'omg-too-long'

  click_button 'smurlify'
end

Then /^I should see a custom url error message$/ do
  expect(page).to have_content "Custom url can only contain"
end