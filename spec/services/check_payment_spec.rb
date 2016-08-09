require 'rails_helper'

describe CheckPayment do
  describe '#perform' do
    context 'auction is closed, unpaid, for 18F pcard' do
      context 'not purchased in C2' do
        it 'checks for payment updates' do
          c2_path = 'proposals/1234'
          auction = create(
            :auction,
            :payment_needed,
            purchase_card: :default,
            c2_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
          )

          CheckPayment.new.perform

          expect(auction.reload.paid_at).to be_nil
        end
      end

      context 'purchased in C2' do
        it 'checks for payment updates' do
          c2_path = "proposals/#{FakeC2Api::PURCHASED_PROPOSAL_ID}"
          auction = create(
            :auction,
            :payment_needed,
            purchase_card: :default,
            c2_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
          )

          CheckPayment.new.perform

          expect(auction.reload.paid_at).not_to be_nil
        end

        it 'sends an email to the vendor' do
          c2_path = "proposals/#{FakeC2Api::PURCHASED_PROPOSAL_ID}"
          auction = create(
            :auction,
            :payment_needed,
            purchase_card: :default,
            c2_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
          )
          mailer_double = double(deliver_later: true)
          allow(AuctionMailer).to receive(:auction_paid_winning_vendor_notification)
            .with(auction: auction)
            .and_return(mailer_double)

          CheckPayment.new.perform

          expect(AuctionMailer).to have_received(:auction_paid_winning_vendor_notification)
            .with(auction: auction)
          expect(mailer_double).to have_received(:deliver_later)
        end
      end
    end

    context 'auction is closed, paid' do
      it 'does not check for payment updates' do
        create(:auction, :closed, :paid)
        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:get)

        CheckPayment.new.perform

        expect(c2_client_double).not_to have_received(:get)
      end
    end

    context 'auction is closed, unpaid, not for 18F pcard' do
      it 'does not check for payment updates' do
        create(:auction, :closed, :not_paid, purchase_card: :other)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:get)

        CheckPayment.new.perform

        expect(c2_client_double).not_to have_received(:get)
      end
    end
  end
end
