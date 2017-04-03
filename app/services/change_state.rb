class ChangeState
  def initialize(auction, state_name, state_value)
    @auction = auction
    @state_name = state_name
    @state_value = state_value
  end

  def perform
    state.state_value = state_value
    state.save
  end

  def state
    @state ||= find_or_build_state_record
  end

  def self.perform(auction, name, value)
    new(auction, name, value).perform
  end

  private

  attr_reader :auction, :state_name, :state_value

  def find_or_build_state_record
    find_state_record || build_state_record
  end

  def find_state_record
    auction.states.find {|state| state.name == state_name}
  end

  def build_state_record
    auction.states.build(name: state_name, state_value: state_value)
  end
end
