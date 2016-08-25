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

      it 'should send the payment receipt to C2' do
        auction = create(:auction, :paid)

        expect(UpdateC2ProposalJob).to receive(:perform_later)
          .with(auction.id, 'AddReceiptToC2ProposalAttributes')

        ConfirmPayment.new(auction).perform
      end
    end
  end
end
