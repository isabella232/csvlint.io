Then(/^I should see a page of validation results$/) do
  page.body.should include("Validation Results")
end

Then(/^I should see my URL$/) do
  page.body.should include(@url)
end

Then(/^my file should be persisted in the database$/) do
  Validation.count.should == 1
  Validation.first.filename.should == File.basename(@file)
end

Then(/^my url should be persisted in the database$/) do
  Validation.count.should == 1
  Validation.first.url.should == @url
  filename = File.basename(URI.parse(@url).path)
  Validation.first.filename.should == filename
end


Then(/^the database record should have a "(.*?)" of the type "(.*?)"$/) do |category, type|
  result = Marshal.load(Validation.first.result)
  result.send(category.pluralize).first.type.should == type.to_sym
end

Then(/^I should see my schema URL$/) do
  page.body.should include(@schema_url)
end