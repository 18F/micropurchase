require 'rails_helper'

describe RulesFactory do
  describe '#create' do
    context 'sealed bid' do
      it 'returns SealedBidAuction rules' do
        auction = build(:auction, type: :sealed_bid)

        rules = RulesFactory.new(auction).create

        expect(rules).to be_an_instance_of(Rules::SealedBidAuction)
      end
    end

    context 'reverse' do
      it 'returns Basic rules' do
        auction = build(:auction, type: :reverse)

        rules = RulesFactory.new(auction).create

        expect(rules).to be_an_instance_of(Rules::ReverseAuction)
      end
    end
  end
end
