require 'rails_helper'

describe LosingBidderEmailSender do
  describe '#perform' do
    context 'auction has losing bidders' do
      context 'all bidders have an email address' do
        it 'emails all losing bidders' do
          auction = create(:auction, :closed)
          _winning_bid = create(:bid, amount: 1, auction: auction)
          losing_bid = create(:bid, amount: 100, auction: auction)
          second_losing_bid = create(:bid, amount: 101, auction: auction)
          mailer_double = double(deliver_later: true)
          allow(AuctionMailer).to receive(:losing_bidder_notification).
            with(losing_bid).
            and_return(mailer_double)
          allow(AuctionMailer).to receive(:losing_bidder_notification).
            with(second_losing_bid).
            and_return(mailer_double)

          LosingBidderEmailSender.new(auction).perform

          expect(AuctionMailer).to have_received(:losing_bidder_notification).with(losing_bid)
          expect(AuctionMailer).to have_received(:losing_bidder_notification).with(second_losing_bid)
        end
      end

      context 'some bidderes do not have an email address' do
        it 'only emails losing bidders with an email address' do
          auction = create(:auction, :closed)
          _winning_bid = create(:bid, amount: 1, auction: auction)
          user_with_email = create(:user, email: 'test@example.com')
          losing_bid_with_email = create(:bid, bidder: user_with_email, amount: 100, auction: auction)
          user_without_email = create(:user, email: nil)
          _losing_bid_no_email = create(:bid, bidder: user_without_email, amount: 100, auction: auction)
          mailer_double = double(deliver_later: true)
          allow(AuctionMailer).to receive(:losing_bidder_notification).
            with(losing_bid_with_email).
            and_return(mailer_double)

          LosingBidderEmailSender.new(auction).perform

          expect(AuctionMailer).to have_received(:losing_bidder_notification).with(losing_bid_with_email)
        end
      end
    end

    context 'auction has one (winning) bid' do
      it 'doesnt send any emails' do
        auction = create(:auction, :closed)
        _winning_bid = create(:bid, amount: 1, auction: auction)
        allow(AuctionMailer).to receive(:losing_bidder_notification)

        LosingBidderEmailSender.new(auction).perform

        expect(AuctionMailer).not_to have_received(:losing_bidder_notification)
      end
    end

    context 'auction has no bids' do
      it 'doesnt send any emails' do
        auction = create(:auction, :closed)
        allow(AuctionMailer).to receive(:losing_bidder_notification)

        LosingBidderEmailSender.new(auction).perform

        expect(AuctionMailer).not_to have_received(:losing_bidder_notification)
      end
    end
  end
end
