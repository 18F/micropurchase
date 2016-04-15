# How We Are Trying To Limit Technical Debt

Rails is a great framework for getting started quickly. You just need
to generate a few models and off you go! The problem is that this
invariably leads to unused and undermaintained code accumulating in
different places like your models, views, and controllers all over
your project. We have all learned a few basic mantras like "fat
models, thin controllers" to combat some of this cruft, but it still
leads to your models acquiring hundreds of methods and your views as
branching nests of conditionals. We're trying a few techniques on this
project to forestall that that could be summarized with the following principles:

1. Long model classes are bad
2. NullObject is better than nil
3. View logic should not be in the templates

This document will explore how we try to adhere to these principles in
how we organize the project. We don't usually design with these
approaches up front -- it's often more effective to refactor after the
fact -- and there are definitely areas where code could be improved
still. But it's a continuous process we are learning from and
implementing when it's time to reengineer certain components. We are
indebted to Kane Baccigalupi for all her insight and experience with
this approach.

# Presenters

Long classes are often flagged as a code smell because it's hard to
keep track of all the methods within them and easy to keep around
methods that a developer built in case someone needed it (nobody did)
or worse still to reimplement another method under a new name
(display_price, formatted_price, page_price). Similarly, long classes
are often trying to fulfill several distinct purposes at once, which
compromises their conceptual clarity and makes it confusing for new
developers to understand how they work.

We tackle that by using Plain Old Ruby Objects (POROs) to wrap our
basic classes in additional functionality when we need it. This is
called the Decorator pattern if you are used to design patterns, but
we tend to give these classes different names based on their
functionality. Here is a
[good primer on various ways in which this approach can clean up Rails projects](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/)
if you wanted a bit more background, but this is how we apply it to
this project.

If you don't now what a Decorator is, it's an object that wraps
another object inside of it and can delegate some methods to the
internal object directly and define new methods of its own.

I'm going to look at the Auction model and the various classes around
it as an example of how we are applying this approach:

1. [Auction](app/models/auction.rb): this is the ActiveRecord class
   you'd expec. We use this for only basic DB access methods as well
   as defining AR relationships. You could also put named scopes here,
   but hold off on that since it's another way to accumulate things
   you don't need.
2. [Presenter::Auction](app/models/presenter/auction.rb) we usually wrap the AR auction in this class
   and this is where we put a lot of the basic display code or
   conditionals like `available?` that normally might be stuck inside
   the AR model class.
3. [Presenter::AdminAuction](app/models/presenter/admin_auction.rb): Since there are some fields in the
   `Auction` DB table that should only be used by administrators, we
   also have a class that is only used in the admin controllers that
   delegates to the regular presenter and also can access privileged
   fields. The regular `Presenter::Auction` does not delegate access
   to those fields, so we get basic access control for the two
   different roles.
4. [ViewModel::Auction](app/models/view_model/auction.rb): Many of the methods in `Presenter::Auction` were only used for
   displaying the auction inside HTML views(for instance,
   `show_bid_button?` or `lowest_user_bid`). These were moved to this
   method which is a wrapper around a `Presenter::Auction` object and
   the `current_user` so we don't need to pass the user in to many of
   these methods.
5. [AuctionQuery](app/models/auction_query.rb): instead of using a
   bunch of named scopes, that might be called within controllers,
   this class is where all queries are defined. This lets us see all
   the types of queries being run against our model. It also makes
   sure the query is executed within the controller method (Rails will
   defer scopes until use, meaning you see an obscure error in your
   view when the query results are first used there).
6. [AuctionParser](app/models/auction_parser.rb): this class defines
   all the logic for taking input from the admin form and
   creating/updating an Auction object. This lets us define custom
   validation or transformations for form fields before creating an
   Auction AR object.
7. [CreateAuction](app/models/create_auction.rb) et al: instead of
   putting the logic for modifying Auction objects in the model,
   presenter or the controller, we have defined several action classes
   to keep that logic self-contained in a single testable class.

So, we've taken code that would all just be located in our AR model
and spread it across several different objects. This might seem
perplexing at first, but it keeps each of our classes relatively small
and singular and purpose and once you understand why everything is
located where it is, it makes more sense.

# Action Classes

One of the tenets of this design is that all important actions on an
object should be placed into their own separate classes. These are
sometimes called Service Objects or Policy Objects, but I prefer to
call them Action Classes. Each of these classes implements at least
two public methods:

1. `initialize` for setting the object or whatever else the action needs to run
2. `perform` for executing the action and returning the object

This changes the way the controllers interact with objects. Instead of
calling ActiveRecord methods directly, the controller instantiates an
object for an action and calls its Perform method. So, here is how the
auctions_controller records a new bid:

```ruby
@bid = Presenter::Bid.new(PlaceBid.new(params, current_user).perform)
```

In this case, the controller is
instantiating a new `PlaceBid` object, then calling `perform` on it
and then wrapping the ActiveRecord `Bid` object returned in a
`Presenter::Bid` object. This might seem weird at first -- OOP urges
us to think of our classes as nouns instead of verbs -- but it offers
certain advantages over controllers calling models directly. It lets
us place auditing or other controls in a single place without having
to edit controllers or API methods to be consistent. It also would be
simple to switch to an asynchronous job-based approach for any actions
should we need to. And we can test the action with unit tests instead
of controller tests.

# View Models

View Models are a common approach for solving two other issues that
commonly strike Rails projects of a certain complexity. We've all had
projects where there are views that are filled with a lot of `<% if
... > <% elsif %> <% end %>` logic, and view templates are really the
worse place to express and see how much branching logic you have. The
second issue is about Rails helpers. All helpers basically are defined
in a single global namespace and as the number of methods goes up, the
more unwieldy your project's codebase becomes. It's hard to know if
you can tweak or remove code in a helper without changing a view that
uses that method elsewhere.

We solve both of these issues by defining a specific new decorator
class that's used for wrapping the objects and helpers needed by a
specific controller view. So, for the `auctions_controller#show`
method, we have defined a
[ViewModel::AuctionShow](app/models/view_model/auction_show.rb) class
that wraps the current user and the auction we are showing. This lets
us scope our view's helpers to be specific to this view model (or to
delegate to the shared `ViewModel::Auction` object). Furthermore,
instead of doing inline conditionals in our views, we can instead
define new partials for each distinct switch of the page's logic and
replace that convoluted branching code in the partial with a helper
method in the View Model that returns which partial to render:

``` html+erb
<div>
<p class="auction-label"><%= @view_model.auction_status_header %></p>
<p class="auction-label-info"><%= render partial: @view_model.auction_status_partial %></p>
</div>
```

This makes our views smaller and more modular and lets us test which
partial to render as a unit test instead of a functional test should
we decide to do that.

# Polymorphism Is Better Than Case Statements

Sometimes your have a situation where there are several related
methods which have the same branching logic inside. For instance, we
might have a method for an auction label and an auction stylesheet
class and an auction display type, each of which checks if the auction
is open or expiring or closed or such to determine what value to
return.

The risk of such an approach is that you might forget a branching
conditional in one of these methods and it creates a lot of tedious
complexity even if you don't. To fix this, there are a few places
where we delegate to an associated object and use polymorphism. So, we
can define classes like `ViewModel::Status::Open` and
`ViewModel::Status::Closed` each with its own methods like `label` or
`status` that the auction presenter can delegate to by calling an
instance of the appropriate class.


``` ruby
delegate :status, :label_class, :label, :tag_data_value_status,
         :tag_data_label_2, :tag_data_value_2,
         to: :status_presenter

private

def status_presenter_class
  status_name = if auction.expiring?
                  'Expiring'
                elsif auction.over?
                  'Over'
                elsif auction.future?
                  'Future'
                else
                  'Open'
                end
  "::ViewModel::AuctionStatus::#{status_name}".constantize
end

def status_presenter
  @status_presenter ||= status_presenter_class.new(self)
end
```

This isn't really worth it for a little repetition in two methods, but
it can be very convenient if you find yourself repeating the same
conditionals in many methods.

# Null Objects

Polymorphism is also useful for reducing the logic of null responses. Too often, we have code like this

``` ruby
user_bid = auction.user_bid

if user_bid.nil?
  "n/a"
else
  user_bid.display_amount
end
```

or such. This is a bit strange since it means that downstream users of
an object have to expect either an object or a nil in all the places
they call your methods. This means a lot of branching and also the
possibility for some nils triggering fatal errors. What if instead of
returning nil, we could define an Null class like this

``` ruby
class Presenter::Bid
  def display_amount
    bid.amount
  end

  class Null
    def display_amount
      "n/a"
    end
  end
end
```

Then, the `user_bid` method would return either an instance of
`Presenter::Bid` or `Presenter::Bid::Null`, both of which define a
`display_amount` method. This then lets us redefine our original code
to just be

``` ruby
user_bid = auction.user_bid
user_bid.display_amount
```

Much cleaner. There are a few places where we define `Null`
equivalents to the `Presenter::Bid` and `Presenter::User` object for
instance.

# What's Next?
