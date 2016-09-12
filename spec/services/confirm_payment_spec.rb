require 'rails_helper'

describe ConfirmPayment do
  describe '#perform' do
    context 'when the vendor has been paid' do
      it 'should update the auction c2_status to payment_confirmed' do
        auction = create(:auction, :paid)

        expect do
          ConfirmPayment.new(auction).perform
        end.to change { auction.c2_status }.to('payment_confirmed')
      end
    end
  end
end
