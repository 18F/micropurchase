require 'rails_helper'

describe AcceptAuction do
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

          AcceptAuction.new(auction).perform

          expect(AuctionMailer).to have_received(:auction_accepted_customer_notification)
            .with(auction: auction)
          expect(mailer_double).to have_received(:deliver_later)
        end
      end

      context 'customer does not have an email' do
        it 'does not send an email to the customer' do
          customer = create(:customer, email: nil)
          auction = create(:auction, :with_bidders, customer: customer)
          winning_bidder = WinningBid.new(auction).find.bidder
          winning_bidder.update(credit_card_form_url: 'test@example.com')
          allow(AuctionMailer).to receive(:auction_accepted_customer_notification)

          AcceptAuction.new(auction).perform

          expect(AuctionMailer).not_to have_received(:auction_accepted_customer_notification)
        end
      end
    end

    context 'auction does not belong to a customer' do
      it 'does not send an email' do
        auction = create(:auction, :with_bidders, customer: nil)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(credit_card_form_url: 'test@example.com')
        allow(AuctionMailer).to receive(:auction_accepted_customer_notification)

        AcceptAuction.new(auction).perform

        expect(AuctionMailer).not_to have_received(:auction_accepted_customer_notification)
      end
    end

    context 'winning bidder does not have credit card information' do
      it 'sends an email to the winner' do
        auction = create(:auction, :with_bidders)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(credit_card_form_url: '')
        mailer_double = double(deliver_later: true)
        allow(AuctionMailer).to receive(:winning_bidder_missing_payment_method)
          .with(auction: auction)
          .and_return(mailer_double)

        AcceptAuction.new(auction).perform

        expect(AuctionMailer).to have_received(:winning_bidder_missing_payment_method)
          .with(auction: auction)
        expect(mailer_double).to have_received(:deliver_later)
      end
    end
    context 'winning bidder has credit card information' do
      it 'enqueues the UpdateC2ProposalJob' do
        auction = create(:auction, :with_bidders)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(credit_card_form_url: 'test@example.com')
        allow(UpdateC2ProposalJob).to receive(:perform_later)

        AcceptAuction.new(auction).perform

        expect(UpdateC2ProposalJob).to have_received(:perform_later).with(auction.id)
      end

      it 'sets accepted_at' do
        auction = create(:auction, :with_bidders)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(credit_card_form_url: 'test@example.com')
        time = Time.parse('10:00:00 UTC')

        Timecop.freeze(time) do
          auction = create(:auction, :with_bidders, accepted_at: nil)

          AcceptAuction.new(auction).perform

          expect(auction.accepted_at).to eq time
        end
      end
    end
  end
end
