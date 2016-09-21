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
2. Composition/delegation is better than inheritance
3. NullObject is better than nil
4. View logic should not be in the templates

This document will explore how we try to adhere to these principles in
how we organize the project. We don't usually design with these
approaches up front -- it's often more effective to refactor after the
fact -- and there are definitely areas where code could be improved
still. But it's a continuous process we are learning from and
implementing when it's time to reengineer certain components. We are
indebted to Kane Baccigalupi for all her insight and experience with
this approach.

# An Illustrated Walkthrough

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

If you don't know what a Decorator is, it's an object that wraps
another object inside of it. It might delegate methods directly to an
encapsulated class -- so a method like `available?` might just call
that method on the internal object -- and it might define new specific
methods that use one more or more contained objects. Decorators can
wrap other decorators in turn, although once you get a few levels
deep, it gets hard to figure out all the delegation and exactly
_where_ that method you are calling is defined, so resist the urge to
make the stack too deep.
`
Because we want to avoid large classes that contain many methods, we
have a large number of small classes that each contain only a few
methods. It can be a bit hard to understand where to start, but this
document is here to help! And to be helpful, we have grouped these
classes into broad subtypes of functionality:

1. ActiveRecord models
2. Ruby classes for basic non-AR-backed models
3. Presenters that wrap basic objects and provide special display functionality
4. ViewModels that collect methods for rendering objects on a page
5. Services that represent specific actions on objects
6. Parsers for creating and updating objects from form input
7. Validators that apply specific checks to objects
8. Serializers for converting objects to machine-readable outputs
9. Authenticators objects for representing specific authentication mechanisms

## A Basic Request

I'm going to look at the Auction model and the various classes around
it as an example of how we are applying this approach. Here is the code from the controller for executing the list of controllers on the homepage:

``` ruby
def index
  @auctions = AuctionsIndexViewModel.new(
    auctions: published_auctions,
    current_user: current_user
  )
end

def published_auctions
  @_published_auctions ||= AuctionQuery.new.public_index
end
```

The classes involved in this exercise give a good illustration of how
the various classes relate:

1. [AuctionQuery](../app/models/auction_query.rb): this is the class
   where all queries against the Auction model are defined instead of
   using a bunch of named scopes in the AR model. The
   `AuctionQuery#public_index` method returns a list of Auction
   objects in reverse chronological order. Defining the methods here
   instead lets us keep the AR model clean and gives us an easy way to
   wrap responses in decorated objects if we need it. It also lets us
   forcibly execute the scopes where they are called in the controller
   (Rails will defer scopes until use, meaning you see an obscure
   error in your view when the query results are first used there).
2. [Auction](../app/models/auction.rb): this is the ActiveRecord class
   you'd expec. We use this for only basic DB access methods as well
   as defining AR relationships. You could also put named scopes here,
   but hold off on that since it's another way to accumulate things
   you don't need. The only thing that should go in the AR model are
   truly basic methods that apply to everything, but resist the urge
   to add new methods in there first.
3. The `current_user` in this case is actually an delegated method in
   the
   [ApplicationController](../app/controllers/application_controller.rb)
   that calls the method in an internal instance of either the
   [WebAuthenticator](../app/models/web_authenticator.rb) or
   [ApiAuthenticator](../app/models/api_authenticator.rb) that was used
   to authenticate the user depending on which mechanism they accessed
   the application through.
4. Both objects are used to construct an
   [AuctionsIndexViewModel](../app/view_models/auction_index_view_model.rb)
   object in the controller. This is then passed to the ERB view that
   renders the page. View Models are convenient places for helper
   methods to render objects correctly as well as conditional branches
   that would otherwise be hidden inside of ERB templates.
5. To render each auction in the list on the page, the ViewModel maps
   each auction object in the `public_auctions` array to an
   [AuctionListItem](../app/view_models/auction_list_item.rb)
   object. This object contains useful methods for rendering
   attributes of an auction like `user_bid_amount_as_currency` as well
   as methods for picking the appropriate partials to display
   depending on the auction and user.
7. The `AuctionListItem` class also delegates to methods from an internal
   object. So, a call to `AuctionListItem#available?` within a view
   will actually call an internal variable instance of the
   [BiddingStatus](../app/models/bidding_status.rb) with that
   method. This approach lets us collect related functions like _all
   the methods for querying the availability of an auction_ in a single
   focused place unlike having them be scattered among many methods in
   the `Auction` base class for instance.
8. In some cases, the method is called against an internal instance
   variable that could be one of several distinct types depending on
   the auction and or user. For instance, we demarcate an auction on
   the home page with an OPEN, CLOSED, EXPIRING or FUTURE label
   depending on what the current status of the auction is. Instead of
   using a series of `if-elsif-elsif-end` statements, this is
   accomplished through polymorphism. The
   [StatusPresenterFactory](../app/models/status_presenter_factory) class
   selects an appropriate presenter for the auction status and returns
   an object that supplies the appropriate values for labels or titles
   as needed.
7. We have also designed some basic presenters for transforming raw
   values from AR models to standardized formats we want to display to
   users. So, the `AuctionListItem` class calls such presenters as
   [Currency](../app/presenters/currency.rb) for monetary amounts and
   [HumanTime](../app/presenters/human_time.rb). Another big presenter is
   [DcTimePresenter](../app/presenters/dc_time_presenter.rb) that is used
8. And if there is a concept whose meaning might change depending on
   the auction or user that is used in several places, it makes sense
   to define an appropriate class for encapsulating that logic in a
   single place and instantiating as needed. So, the
   [WinningBid](../app/models/winning_bid.rb) object is a class that
   represents the concept of a winning bid, whose implementation might
   vary depending on the auction (and whether the auction is closed or
   not)

This might seem complicated at first when compared to Rails' basic
Model-View-Controller organization, but it provides a much more solid
way of handling rapid growth of functionality and avoiding large files
that contain every function under the sun and are unusable as a
result.

## Users Place Bids

Rendering auctions is one thing, but this system must also handle user
interaction and do that in such a way that the functionality is
clean. Normally, this might mean a lot of spaghetti code in either
controllers or AR models depending on which developer wins the fight
over where the code should go, but to keep things clean, we should
define all that in other types of classes we haven't seen
already. Let's look at what happens when a user places a bid. Here is
the relevant code in the controller:

``` ruby
@bid = PlaceBid.new(params: params, user: current_user, via: via).perform

respond_to do |format|
  format.html do
    flash[:bid] = "success"
    redirect_to auction_path(@bid.auction)
  end
  format.json do
    render json: @bid, serializer: BidSerializer
  end
end
```

This hits a few other types of classes:

1. [PlaceBid](../app/services/place_bid) is a Service object that
   represents a specific action that changes the state of the system
   with all the information needed to execute it. In this case, we
   instantiate it with the parameters from the controller, the current
   user and a flag to indicate whether the bid came via the web or
   API. Its `perform` method in turn instantiates the auction from the
   ID, verifies that the user can indeed place a bid and the amount is
   valid, and returns the `Bid` object created.
2. [PlaceBidValidator](../app/validators/place_bid_validator.rb) is
   what does the actual validation of a potential bid. This follows
   the established convention for Rails applications in which custom
   validation should appear in its own validation classes. Although we
   have gone beyond the basic organizational approach in some cases
   (and ignored them in a few cases like ViewModels, which are much
   more powerful and scoped compared to helper methods), we try to
   stick to Rails' conventions as much as possible. This would also
   allow us to use the validation if we had another mechanism for
   creating bids that was separate from PlaceBid.
3. Because different auctions have different rules on eligible bids --
   for instance, a sealed-bid auction only allows the user to bid
   once, while a regular auction requires that the new bid must be
   lower than all other bids -- `PlaceBidValidator` calls a
   [RulesFactory](../app/models/rules_factory.rb) to load the appropriate
   rules for the auction. A rules class like
   [Rules::ReverseAuction](../app/models/rules/reverse_auction.rb)
   [Rules::SealedBidAuction](../app/models/rules/sealed_bid_auction.rb) encapsulates
   rules about what the maximum allowed bid is, whether to show all
   bids.
4. Serializers like [BidSerializer](../app/serializers/bid_serializer.rb)
   or [AuctionSerializer](../app/serializer/auction_serializer.rb)
   describe how to represent objects as data in API responses. Because
   we want to return more information to administrators, there are
   also equivalent serializers for the admin controllers that return
   privileged fields in their responses.

## Administrators Create Auctions

One last example to reinforce how things are organized. When an
administrator creates a new auction, the relevant code in the
controller looks like this:

``` ruby
@auction = BuildAuction.new(params, current_user).perform

```

1. [BuildAuction](../app/services/build_auction.rb) is another Service
   object that represents the action of creating an auction and sticks
   to the familiar pattern with a `perform` method.
2. Within this class, the
   [AuctionParser](../app/models/auction_parser.rb) handles the process
   of validating input from the forms and converting it to the
   appropriate types in some cases. We defer most of our auction
   validation until the auction is published, but other parsing
   classes like the [DateTimeParser](../app/models/date_time_parser.rb)
   handle specific data conversion tasks.

The `AuctionParser` and its related classes are the final major
subtype of classes in our code and with that our tour is complete.

# What Goes Where

The scenarios above should've given a rough overview of the various
models in actual use, but here are some additional details on our
organizational style.

## Action Classes

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
@bid = BidPresenter.new(PlaceBid.new(params, current_user).perform)
```

In this case, the controller is instantiating a new `PlaceBid` object, then
calling `perform` on it and then wrapping the ActiveRecord `Bid` object returned
in a `BidPresenter` object. This might seem weird at first -- OOP urges us to
think of our classes as nouns instead of verbs -- but it offers certain
advantages over controllers calling models directly. It lets us place auditing
or other controls in a single place without having to edit controllers or API
methods to be consistent. It also would be simple to switch to an asynchronous
job-based approach for any actions should we need to. And we can test the action
with unit tests instead of controller tests.

## View Models

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
[AuctionShowViewModel](../app/view_models/auction_show_view_model.rb) class
that wraps the current user and the auction we are showing. This lets
us scope our view's helpers to be specific to this view model (or to
delegate to the shared `AuctionShowViewModel` object). Furthermore,
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

## Polymorphism Is Better Than Case Statements

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
can define classes like `AuctionStatus::OpenViewModel` and
`AuctionStatus::ClosedViewModel` each with its own methods like `label` or
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
  "::AuctionStatus::#{status_name}ViewModel".constantize
end

def status_presenter
  @status_presenter ||= status_presenter_class.new(self)
end
```

This isn't really worth it for a little repetition in two methods, but
it can be very convenient if you find yourself repeating the same
conditionals in many methods.

Similarly, we have a few places where we branch depending on the
auction type. This will likely make a good candidate for similar
refactoring in the future.

## Composition is Better than Inheritance

The way we handle different rules for different types of auctions is a
good example of how we favor composition/delegation over large
inherited types. Currently we have two different types of auctions --
a basic descending-value auction where all bid amounts are visible
during the process and a sealed-bid auction where each user can only
bid once and the winner is revealed when the auction is lower. We
might add more, but these auctions have slightly different behavior
from each other in a few different ways:

1. Can the user bid on this auction?
2. Should I show the user the amounts of other bids?
3. Is this bid from the user valid?
4. What summary information should I show for the auction on the home page?
5. What summary information should I show for the auction on the auction's page?
6. Should the user be able to see a list of bids when the auction is open? When it's closed?

and so on. We might consider implementing this by defining a
`ReverseAuction` class and also a `SealedBidAuction` class with the
variations encoded within. And this works okay, but what if we decide
to add some more auction types? For instance, a
`ReverseAuctionWithBuyNowButton` or a
`SealedBidOnlyForSmallBusinessVendorsAuction` or a
`ReverseAuctionForSmallBusinessVendorsWithBuyNowButton` or such?
Ruby's single-inheritance starts to get unwieldy fast and what we
really want is some sort of idea of mixins. So what if we do that.

Right now, there are several distinct places where we need to know
what the Rules for an auction specify: when we are rendering a page,
when we are validating a bid, when we show a winner. Currently both
auctions are over when time is up, but if we added a Buy Now button,
auction availability would also vary according to the rules. We could
implement these variations as a sequence of `if-then-else` statements,
but it's better to extract to polymorphism like above. And so, we have
a series of `Rules` objects and auctions specify in a field which
rules they use, but all are of the same `Auction` type. When we need
to also specify Eligibility separately, we can do that with a
different field without creating an OOP explosion.

## Null Objects

Polymorphism is also useful for reducing the logic of null
responses. Too often, we have code like this

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
class BidPresenter
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
`BidPresenter` or `NullBidPresenter`, both of which define a
`display_amount` method. This then lets us redefine our original code
to just be

``` ruby
user_bid = auction.user_bid
user_bid.display_amount
```

Much cleaner. There are a few places where we define `Null`
equivalents to the `BidPresenter` and `UserPresenter` object for
instance.

One other example of this technique is the
[Guest](../app/models/guest.rb) class. So much of the application is
oriented towards users being logged in, but we should handle cases
when there is no user logged in. Instead of checking if
`current_user.nil?` everywhere, the `WebAuthenticator` instead returns
a `Guest` object if no user is logged in.

``` ruby
def current_user
  @current_user ||= User.where(id: controller.session[:user_id]).first || Guest.new
end
```

This is turn is wrapped by the
[GuestPresenter](../app/presenters/guest_presenter.rb), which allows
the app to specify special partials for guests instead of regular
users

``` ruby
  def nav_drawer_partial
    "components/guest_nav_drawer"
  end

  def win_header_partial
    "auctions/reverse/guest_win_header"
  end

  def nav_drawer_submenu_partial
    "components/guest_nav_drawer_submenu"
  end
```

## You Have To Make Things Worse Before You Make Things Better

This structure was not created in advance and filled in
later. Instead, this is the Nth iteration and reorganization of
existing code. It's perfectly okay if things get messy and code is
duplicated or classes collapsed first before you start
refactoring. Don't be afraid to commit ugly and transitional steps on
the way to a cleaner organization, as long as you stick to three basic
rules:

1. Don't try to commit too many changes in a single pull request
2. Make sure the tests pass and cover all your new code
3. Relax about CodeClimate/Rubocop and other scores until you're done with the messy work

And remember that sometimes you might have to abandon a particular
effort because it doesn't work or is too unwieldy. That's okay. You
learned something in the process that will make the next attempt
better.

# Further Reading

* [Practical Object-Oriented Design in Ruby](http://www.sandimetz.com/products)
* [Objects on Rails](http://objectsonrails.com/)
* [Sevice Objects](https://github.com/justin808/fat-code-refactoring-techniques/pull/6)
* [Nothing is Something](https://www.youtube.com/watch?v=OMPfEXIlTVE)
