Before do 
  CustomUrl.destroy
  SmallUrl.destroy
end

def submit_small_url url, vanity=nil
  visit '/'

  fill_in 'url', with: url
  fill_in 'vanity', with: vanity

  click_button 'smurlify'
end