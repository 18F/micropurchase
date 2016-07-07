require 'rails_helper'

describe AuctionAcceptedEmailSender do
  describe '#perform' do
    context 'auction belongs to a customer' do
      context 'customer has an email' do
        it 'sends an email to the customer' do
          customer = create(:customer, email: 'test@example.com')
          auction = create(:auction, customer: customer)
          mailer_double = double(deliver_later: true)
          allow(AuctionMailer).to receive(:auction_accepted_customer_notification)
            .with(auction: auction)
            .and_return(mailer_double)

          AuctionAcceptedEmailSender.new(auction).perform

          expect(AuctionMailer).to have_received(:auction_accepted_customer_notification)
            .with(auction: auction)
        end
      end

      context 'customer does not have an email' do
        it 'does not send an email to the customer' do
          customer = create(:customer, email: nil)
          auction = create(:auction, customer: customer)
          allow(AuctionMailer).to receive(:auction_accepted_customer_notification)

          AuctionAcceptedEmailSender.new(auction).perform

          expect(AuctionMailer).not_to have_received(:auction_accepted_customer_notification)
        end
      end
    end

    context 'auction does not belong to a customer' do
      it 'does not send an email' do
        auction = create(:auction, customer: nil)
        allow(AuctionMailer).to receive(:auction_accepted_customer_notification)

        AuctionAcceptedEmailSender.new(auction).perform

        expect(AuctionMailer).not_to have_received(:auction_accepted_customer_notification)
      end
    end
    end
end
