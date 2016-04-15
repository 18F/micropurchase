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
still. But it's a continuous process we are learning from.

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

1. First there is the ActiveRecord `Auction` class. We use this for
   only basic DB access methods as well as defining AR
   relationships. You could also put named scopes here, but hold off
   on that since it's another way to accumulate things you don't need.
2. `Presenter::Auction` we usually wrap the AR auction in this class
   and this is where we put a lot of the basic display code or
   conditionals like `available?` that normally might be stuck inside
   the AR model class.
3. `Presenter::AdminAuction`: Since there are some fields in the
   `Auction` DB table that should only be used by administrators, we
   also have a class that is only used in the admin controllers that
   delegates to the regular presenter and also can access privileged
   fields. The regular `Presenter::Auction` does not delegate access
   to those fields, so we get basic access control for the two
   different roles.
4. `ViewModel::Auction`: Many of the methods in `Presenter::Auction` were only used for
   displaying the auction inside HTML views(for instance,
   `show_bid_button?` or `lowest_user_bid`). These were moved to this
   method which is a wrapper around a `Presenter::Auction` object and
   the `current_user` so we don't need to pass the user in to many of
   these methods.
5. `AuctionQuery`: instead of using a bunch of named scopes, that
   might be called within controllers, this class is where all queries

# Polymorphism Is Better Than Case Statements

# Action Classes

# ViewModels

# Null Objects
