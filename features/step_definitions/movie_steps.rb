# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    movie['release_date'] = Date.parse(movie['release_date'])
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  first_position = page.body.index(e1)
  second_position = page.body.index(e2)
  expect(first_position).to be < second_position
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(', ')

  ratings.each do |rating|
    if uncheck
      uncheck("ratings[#{rating}]")
    else
      check("ratings[#{rating}]")
    end
  end
end

# Part 2, Step 3
Then /^I should (not )?see the following movies: (.*)$/ do |no, movie_list|
  movies = movie_list.split(', ')
  movies.each do |title|
    if no
      expect(page).not_to have_content(title)
    else
      expect(page).to have_content(title)
    end
  end
end

Then /I should see all the movies/ do
  Movie.all.each do |movie|
    expect(page).to have_content(movie.title)
  end
end

### Utility Steps Just for this assignment.

Then /^debug$/ do
  # Use this to write "Then debug" in your scenario to open a console.
   require "byebug"; byebug
  1 # intentionally force debugger context in this method
end

Then /^debug javascript$/ do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end
