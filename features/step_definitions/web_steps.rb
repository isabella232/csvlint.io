When(/^I go to the homepage$/) do
  visit root_url
end

When(/^I enter "(.*?)" in the "(.*?)" field$/) do |text, field|
  instance_variable_set("@#{field}", text)
  fill_in field, with: text
end

When(/^I press "(.*?)"$/) do |name|
  click_button name
end

When(/^I attach the file "(.*?)" to the "(.*?)" field$/) do |file, field_name|
  @file = file
  attach_file(field_name.to_sym, File.join(Rails.root, 'fixtures', @file))
end

Then(/^I should see "(.*?)"$/) do |text|
  page.body.should include(text)
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.body.should_not include(text)
end

Given(/^I click on "(.*?)"$/) do |link|
  click_link link
end