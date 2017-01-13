require 'rails_helper'

describe ChangeState do
  describe '#initialize' do
    context 'when passing an instance of an unsupported class to the constructor' do
      it 'raises an error' do
        instance_of_unsupported_class = 'a_string_instance'

        expect do
          ChangeState.new(instance_of_unsupported_class, 'a_name', 'a_value')
        end.to raise_error(ChangeState::Error)
      end
    end
  end

  describe '#perform' do
    context 'when passing an Auction to the constructor' do
      context 'when there is no associated AuctionState' do
        it 'creates a new AuctionState record' do
          auction = create(:auction)

          state_name = 'a_state_name'
          state_value = 'a_state_value'

          change_state = ChangeState.new(auction, state_name, state_value)

          expect do
            change_state.perform
          end.to change { AuctionState.count }.by (1)

          auction.reload

          state = auction.states.find {|state| state.name == state_name}

          expect(state.state_value).to eq state_value
        end
      end

      context 'when there is an associated AuctionState' do
        it 'updates the existing AuctionState record' do
          auction = create(:auction)

          state_name = 'a_state_name'
          state_value = 'a_state_value'
          new_state_value = 'a_new_state_value'

          auction.states.build(name: state_name, state_value: state_value)
          auction.save

          change_state = ChangeState.new(auction, state_name, new_state_value)

          expect do
            change_state.perform
          end.to change { AuctionState.count }.by(0)

          auction.reload

          state = auction.states.find {|state| state.name == state_name}

          expect(state.state_value).to eq new_state_value
        end
      end
    end
  end
end
