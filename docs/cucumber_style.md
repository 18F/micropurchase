# Cucumber Style Guide

We have been using Cucumber to implement our user stories and its Gherkin language specifically. Unlike the extant organization for Rspec and Rails, there don't seem to be many style guides for Gherkin. And so it's easy to just accumulate new features that duplicate each other and aren't organized. Similarly, we might define a bunch of redundant steps that do similar things over and over.

I'm going to propose some general rules for how we should write these tests. These are not meant to be final fiats, and I am doing this to provoke a discussion and come to a consensus on how we write these.

## Be Direct With Verbs

Gherkin’s flexibility is a bit of a headache, in that there are many possible ways to write the same thing. The problem with this is that developers might accidentally implement redundant step definitions because the same thing is described in two different ways (ie, “I am an administrator” vs. “I am logged in as a user with administrator rights”). It takes more than just writing things consistently to avoid duplication, but let’s start by embracing a simple and direct style for our rules whenever possible. So, I’d suggest the following basic guidelines for writing steps on a feature

* _I should see the auction’s title_
* _I am an administrator_
* _I visit the auction detail page_
* _I click on the “Submit” button_
* _I fill in the “Bid” field with “1,000”_
* _There is a closed single-bid auction with no bids_
* _I should see “Yes” for “Small Business?” in the “users” table_

That said, there are sometimes challenges that make it hard to follow this style, and it requires some level of consistency in how we frame auctions. And it is something we will probably need to refine as we go along.

## Generalize Steps When Convenient

One interesting thing about Gherkin is that it lets you define regular expressions within steps, so that instead of having a bunch of steps like _Click on the Submit button_, _Click on the Bid button_, etc. you can define a single step like

``` ruby
When(/^I click on the "?([^"]+)"? button$/) do |button|
  first(:link_or_button, button).click
end

```

And it’ll match on the Regexp. There is no requirement that the regular expression need to be within “” in the rule, but I think it helps to better demarcate that this is where the regular expression will be applied. There are still a few stylistic points to be clarified:

* Enclose regexp targets within quotes to visually indicate those are parameters to the feature
* Do not use regexp matchers when the resulting step definition would just be a big case statement. So, I would suggest against a regexp for steps like _I visit the home page_, _I visit the auction page_, etc.)
* Currently I am using possessives for retrieving the attributes of an object (_I should see the auction's title_), since that seems more natural, but should we use a construction like _I should see the "title" of the auction_?
* It's fine to translate arguments within the steps. So, if we had a parameter like `in the "admins" table`, it could translate into a CSS rule to look within a table with the ID of `table-admins`. We should use this as an opportunity to standardize our CSS classes and names instead of using a large case statement.
* If it makes sense, define several steps if you want to allow default actions for parameterized cases. For instance, we could have a step _It should have a column with the value "X" in the "Y" table_ and also one that is _It should have a column with the value "X"_ that just looks at the first table. Don't go crazy defining these though in case you might need them.
* Do not define step definitions that can take regular expressions or other Ruby code snippets as arguments. Gherkin steps are not RSpec matchers and they should always be comprehensible to people who aren't programmers.

## Organizing Our Features and Steps

Cucumber is agnostic about how to organize your features and step definitions. For instance, right now we have one file for bidding features, one for various auction display state and one for closed auctions. This can make it hard to find anything without resorting to grep across your files, so that’s something we should try to address before it becomes impossible to navigate. Since features are supposed to be related to a specific overarching story, I suggest we organize them with the following rough format: _role_verb_object.feature_, so for instance we might have the following feature files:

* vendor_views_closed_sealed_bid_auction
* vendor_bids_on_open_auction
* admin_views_users
* admin_edits_user

Or something similar. This would mean we have many more feature files than we currently have and each feature would have only a few scenarios, but those should make them easier to understand and find.

We probably will not have a corresponding organization for step definitions though. In many cases, the features should share common steps, and I think we should organize steps in a different way, maybe around the objects/domains they are relevant for:

* navigation_steps.rb
* auction_attribute_steps.rb
* user_profile_form_steps.rb

That said, if a specific feature defines its own step that is not used anywhere else, than those steps should be in a file named FEATURENAME_steps.rb

## Be As Specific As Possible

It’s always very tempting to write a feature with steps like there are several different types of auctions but these are not necessarily easy to understand when I read the feature and they are usually very difficult to write tests for. Instead, we should make each step as specific as possible and repeat each of the things we want as distinct scenarios. For instance, I translated one scenario into three

``` cucumber
Scenario: A user that is not a small business
  Given I am an administrator
  And there is a user in SAM.gov who is not a small business
  When I sign in
  And I visit the admin users page
  Then I should see a column labeled "Small Business?"
  And I should see "No" for the user in the "Small Business?" column

Scenario: A user who is a small business
  Given I am an administrator
  And there is a user in SAM.gov who is a small business
  When I sign in
  And I visit the admin users page
  Then I should see a column labeled "Small Business?"
  And I should see "Yes" for the user in the "Small Business?" column

Scenario: A user who is not in SAM.gov
  Given I am an administrator
  And there is a user who is not in SAM.gov
  When I sign in
  And I visit the admin users page
  Then I should see a column labeled "Small Business?"
  And I should see "N/A" for the user in the "Small Business?" column

```

This is easier to understand than a scenario with “there are several types of users.” The only downside is that we are often testing our features as if there is only a single auction/user/bid/etc. in the system. For cases where we need to see how it handles multiple records, we should figure out separate feature for that.

## How to Carry Context Forward?

Gherkin promises the ability to write tests like English, but there are some important distinctions. If we write a sentence from several distinct clauses in English, there is often an implicit context that links them together. For instance, imagine I had the following sentence: When I go to the stove, I should turn off the kettle and pour the water onto the coffee. But in Gherkin, I would probably have to do it as this

``` cucumber
When I go to the stove
Then I should turn off the kettle on the stove
And I should pour the water from the kettle on the stove onto the coffee next to the stove

```

Or so on. Since each Gherkin step is just shorthand for running a few Ruby methods, I have to provide the context if it would be needed by the underlying step. There are a few ways we can do it, both of which have problems.

* We can be explicit in the step as called in the feature file. This is a little bit unwieldy if we read it like English, but it is the most direct on what is happening. And it doesn’t really work well if we try to call a constructor for a test object in Gherkin
* We can have steps define `@variables` which can be used later by other steps. For instance, we could have a step there is a closed sealed-bid auction with bidders that creates an auction and assigns it to @auction. Then a later step I should see the auction’s title could look at @auction.title and see if it’s visible on the page. This lets us be a bit less verbose in our steps (and it means we can avoid the ugly style of writing a constructor in feature steps), but there is a hidden dependency between the two step definitions.

I’m not sure if there is a better way of handling context that should be shared between steps. I wonder if would make sense use tags and hooks in some fashion to at least visually indicate there is a dependency among features.

## Table Inspection Still Awkward

Speaking of linkages, it’s a bit awkward right now to check the value of a table cell. Right now I do this awkwardly by having a lookup array to get the positional offset

``` ruby
Then(/^I should see "([^"]+)" for the user in the "([^"]+)" column$/) do |value, column|
  user_admin_columns = ['Name', 'Email', 'DUNS Number', 'SAM.gov status',
                        'Small Business?', 'Github ID']

  index = user_admin_columns.index(column)
  fail 'Unrecognized column: #{column}' if index.nil?
  css = "table#table-users tbody tr td:nth-child(#{index+1})"

  within(css) do
    expect(page).to have_content(value)
  end
end

```

But this is a bit brittle. This is another case where it would be good to figure out the best way of relative row cells to header names and fixing that.

## Writing Higher-level Steps out of Smaller Steps

Cucumber's sweet spot is integration testing, where we specify how the app should respond to specific interactions from users. But it could be used for much bigger things, like defining rules for compliance or other meta-actions. We should revisit what the best style for these things should be when we get to that point, but it's important to remember that Gherkin step definitions can call other steps from within them and we could define a step like "I create a new auction" that encapsulates an entire sequence of smaller steps.
