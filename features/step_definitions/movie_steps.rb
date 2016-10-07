# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    if (! Movie.find_by_title(movie[:title]))
        Movie.create!(movie)
    end
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  ratings = "G PG PG-13 NC-17 R".split(" ")
  
  ratings.each do |rating|
    uncheck "ratings_#{rating}"
  end
  
  arg1.split(', ').each do |rating|
    check "ratings_#{rating}"
  end
  
  click_button "ratings_submit"
end

When (/^I have opted to alphabetically sort movies$/) do
    click_on "title_header"
end

When (/^I have opted to sort movies in most recent order of release date$/) do
    click_on "release_date_header"
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  ratings = "G PG PG-13 NC-17 R".split(" ")
  
  arg1.split(', ').each do |rating|
    page.has_checked_field? "ratings_#{rating}"
    ratings.delete(rating)
  end
  
  ratings.each do |rating|
    page.has_unchecked_field? "ratings_#{rating}"
  end
end

Then /^I should see all of the movies$/ do
  rows = Movie.all.rows
  rows.should == page.all('table#movies tr').count-1
end

Then (/^I should see movie title "(.*?)" before "(.*?)"$/) do |title1, title2|
    
    titleBool = false
    list = []
    
    all("table#movies tbody/tr/td[1]").each do |title|
        list.push(title.text)
    end
    
    if (list.index(title2) > list.index(title1))
        titleBool = true
    end
    
    expect(titleBool).to be_truthy
end

Then (/^I should see the date "(.*?)" before "(.*?)"$/) do |date1,date2|
    dateBool = false
    list = []
    
    all("table#movies tbody/tr/td[3]").each do |date|
        list.push(date.text)
    end
    
    if (list.index(date2) > list.index(date1))
        dateBool = true
    end
    
    expect(dateBool).to be_truthy
end