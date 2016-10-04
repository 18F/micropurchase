require 'rails_helper'

describe C2CancelAttributes do
  describe '#to_h' do
    it 'constructs the right attributes for archived auctions' do
      auction = create(:auction, :archived)

      attributes = C2CancelAttributes.new(auction).to_h

      expect(attributes[:status]).to eq('cancelled')
      expect(attributes[:gsa18f_procurement][:additional_info])
        .to eq('Reason cancelled: the auction was archived')
    end

    it 'constructs the right attributes for rejected auctions' do
      auction = create(:auction, :rejected)

      attributes = C2CancelAttributes.new(auction).to_h

      expect(attributes[:status]).to eq('cancelled')
      expect(attributes[:gsa18f_procurement][:additional_info])
        .to eq('Reason cancelled: the auction was rejected')
    end
  end
end
