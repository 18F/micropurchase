require 'rails_helper'

describe ChangeState, '#perform' do
  it 'when there is no associated state record, it creates a new record' do
    auction = create(:auction)
    service = ChangeState.new(auction, 'visibility', 'published')

    expect {
      service.perform
    }.to change { auction.states.to_a.length }.by(1)

    service.state.reload
    expect(service.state.name).to eq('visibility')
    expect(service.state.state_value).to eq('published')
  end

  it 'will update of the state record when the state with that name already exsits' do
    auction = create(:auction)
    auction.states.create(name: 'visibility', state_value: 'draft')
    service = ChangeState.new(auction, 'visibility', 'published')

    expect {
      service.perform
    }.to change { auction.states.to_a.length }.by(0)

    service.state.reload
    expect(service.state.state_value).to eq('published')
  end
end
