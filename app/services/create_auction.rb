class CreateAuction
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def perform
    build_auction
    save_auction
    create_auction_states

    auction
  end

  private

  attr_reader :params, :current_user, :auction

  def create_auction_states
    create_published_state
    create_work_state
    # add more states as needed
  end

  def create_published_state
    change_state = ChangeState.new(auction, 'published', 'unpublished')
    change_state.perform
  end

  def create_work_state
    change_state = ChangeState.new(auction, 'work', 'not_started')
    change_state.perform
  end

  def build_auction
    @auction ||= BuildAuction.new(params, current_user).perform
  end

  def save_auction
    SaveAuction.new(auction).perform
  end
end
