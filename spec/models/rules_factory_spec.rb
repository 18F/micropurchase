require 'rails_helper'

describe RulesFactory do
  describe '#create' do
    context 'single bid' do
      it 'returns SealedBid rules' do
        auction = build(:auction, type: :single_bid)

        rules = RulesFactory.new(auction).create

        expect(rules).to be_an_instance_of(Rules::SealedBid)
      end
    end

    context 'multi_bid' do
      it 'returns Basic rules' do
        auction = build(:auction, type: :multi_bid)

        rules = RulesFactory.new(auction).create

        expect(rules).to be_an_instance_of(Rules::Basic)
      end
    end
  end
end
