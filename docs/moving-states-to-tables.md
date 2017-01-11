Refactoring data pattern:
* Build the new data abstraction
* Find all writes
* Write to old and new location (ongoing, evented)
* Backfill task to populate new location (batch)
* Read from the new location
* Remove old writes (in code)
* Remove old fields (in database)

---------
# try this one first:
Published: draft => published | archived


Auction bidding state: not yet bidding -> bidding -> closed
Auction won state: no bids -> won
Auction work state: not started -> in progress -> delivered | not delivered
Work acceptance: not evaluated -> accepted | rejected
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
