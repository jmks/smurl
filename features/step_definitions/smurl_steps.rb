When /^I provide a url to shorten$/ do
  @long_url = 'http://www.toolongfor140charactersorless.com'
  submit_small_url @long_url
end

Then /^I should see the shortened url$/ do
  @small_url = SmallUrl.get_small_url(@long_url)

  expect(page).to have_content @small_url.small_url
end

Given /^the next small url's encoded id is used by a custom url$/ do
  # add 2 since we have to create the first small url
  # HACK: this bypasses SmallUrl's api!
  @first = SmallUrl.create url: "www.herefirst.com", accessed: 0, created_at: Time.now
  CustomUrl.create link: SmallUrl.send(:encode62, @first.id + 1), smurl_id: @first.id 
end

When /^I create a new small url without vanity url$/ do
  @new = SmallUrl.get_small_url "www.newsecond.com"
end

When /^when I visit the new small url link$/ do
  visit @new.small_url
end

Then /^I should be redirected to the new url$/ do
  expect(current_url).to eql @new.full_url
end