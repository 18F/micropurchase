class ChangeState
  def initialize(object, state_name, state_value)
    if !supported_classes.include?(object.class)
      raise_unsupported_class_error
    end

    @object = object
    @state_name = state_name
    @state_value = state_value
  end

  def perform
    state.state_value = state_value
    state.save
  end

  private

  attr_reader :object, :state_name, :state_value

  def state
    find_state || build_state(state_name, state_value)
  end

  def find_state
    object.states.find {|state| state.name == state_name}
  end

  def build_state(state_name, state_value)
    if object.is_a?(Auction)
      AuctionState.new(auction_id: object.id,
                       name: state_name,
                       state_value: state_value)
    else
      raise_unsupported_class_error
    end
  end

  class Error < StandardError
  end

  def supported_classes
    [Auction]
  end

  def raise_unsupported_class_error
    raise ChangeState::Error, "Unsupported class (#{object.class}) passed to constructor in ChangeState"
  end
end
