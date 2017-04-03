Refactoring data pattern:
* Build the new data abstraction
* Find all writes
* Write to old and new location (ongoing, evented)
* Backfill task to populate new location (batch)
* Read from the new location
* Remove old writes (in code)
* Remove old fields (in database)

## splitting apart delivery_status

enum delivery_status: {
  pending_delivery: 0, - (DEFAULT in db)
  work_in_progress: 5, -
  missed_delivery: 6, -
  pending_acceptance: 3, -
  accepted_pending_payment_url: 4,
  accepted: 1, -
  rejected: 2 -
}

work

- not_started (pending_delivery)
- in_progress (work_in_progress)
- delivered (pending_acceptance)
- not_delivered (missed_delivery)

acceptance

- not_evaluated
- accepted (accepted)
- rejected (rejected)

issue: how should information about payment_url be pulled out?

I think we can just stop using payment url info as part of these state buckets.

For example, when we need to find `payment_needed` auctions, we currently use:

```
relation
  .accepted_or_accepted_and_pending_payment_url
  .not_paid
```

If we pull out `delivery_status` into `work` and `acceptance`, then we can find `payment_needed_auctions` with something like:

```
relation
  .accepted
  .missing_payment_url
  .not_paid
```

(note: missing_payment_url scope is not currently implemented)

---------
# try this one first:
Published: unpublished => published | archived

# next up
Auction work state: not started -> in progress -> delivered | not delivered
Work acceptance: not evaluated -> accepted | rejected

Auction bidding state: not yet bidding -> bidding -> closed
Auction won state: no bids -> won

Budget: not requested => requested => approved | rejected
Payment: not paid -> payment sent -> payment confirmed ??


create migration

create_table :auction_states do |t|
  t.string 'name'
  t.string '_value' # reserved :(
  t.int 'auction_id'
end

class SetAuctionState
  def initialize(name, auction)
  end
end

SetAuctionState.new('published', auction).set('published').save

class PublishedAuctionStates
  StateValues =  {
    published: ['not published', 'published', 'archived']
  }.freeze

  def initialize(name, auction)
  end

  #def name
  #  'published'
  #end

  def state
    # @state = AuctionStates.where(auction_id: auciton.id, name: name)
  end

  def new_state
    # AuctionState.new(auction_id: auction.id)
    auction.states.build
  end

  def save
    auction.save
    state.save
  end

  private

  def set(value)
    # validator = "#{name.capitalize.constantize}Validator
    # polymporphism here, for validation
    # do we want to validate the value
    valid_states = StateValues[name]
    raise if !(valid_states.include?(value))
    state._value = value;
  end
end

set_state('visibility', 'published')
