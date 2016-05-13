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
          allow(AuctionMailer).to receive(:losing_bidder_notification)
            .with(bidder: losing_bid.bidder, auction: auction)
            .and_return(mailer_double)
          allow(AuctionMailer).to receive(:losing_bidder_notification)
            .with(bidder: second_losing_bid.bidder, auction: auction)
            .and_return(mailer_double)

          LosingBidderEmailSender.new(auction).perform

          expect(AuctionMailer).to have_received(:losing_bidder_notification)
            .with(bidder: losing_bid.bidder, auction: auction)
          expect(AuctionMailer).to have_received(:losing_bidder_notification)
            .with(bidder: second_losing_bid.bidder, auction: auction)
        end
      end

      context 'some bidders do not have an email address' do
        it 'only emails losing bidders with an email address' do
          auction = create(:auction, :closed)
          _winning_bid = create(:bid, amount: 1, auction: auction)
          user_with_email = create(:user, email: 'test@example.com')
          losing_bid_with_email = create(:bid, bidder: user_with_email, amount: 100, auction: auction)
          user_without_email = create(:user, email: nil)
          _losing_bid_no_email = create(:bid, bidder: user_without_email, amount: 100, auction: auction)
          mailer_double = double(deliver_later: true)
          allow(AuctionMailer).to receive(:losing_bidder_notification)
            .with(bidder: losing_bid_with_email.bidder, auction: auction)
            .and_return(mailer_double)

          LosingBidderEmailSender.new(auction).perform

          expect(AuctionMailer).to have_received(:losing_bidder_notification)
            .with(bidder: losing_bid_with_email.bidder, auction: auction)
        end
      end
    end

    context 'auction has multiple bids from each bidder' do
      it 'only sends one email to each losing bidder' do
        auction = create(:auction, :closed)
        winning_bidder = create(:user)
        losing_bidder = create(:user)
        _winning_bid = create(:bid, amount: 1, bidder: winning_bidder, auction: auction)
        _other_bid = create(:bid, amount: 3, bidder: winning_bidder, auction: auction)
        _losing_bid = create(:bid, amount: 2, bidder: losing_bidder, auction: auction)
        _other_losing_bid = create(:bid, amount: 4, bidder: losing_bidder, auction: auction)
        mailer_double = double(deliver_later: true)
        allow(AuctionMailer).to receive(:losing_bidder_notification).and_return(mailer_double)
        allow(AuctionMailer).to receive(:losing_bidder_notification)
          .with(bidder: winning_bidder, auction: auction)
          .and_return(mailer_double)
        allow(AuctionMailer).to receive(:losing_bidder_notification)
          .with(bidder: losing_bidder, auction: auction)
          .and_return(mailer_double)

        LosingBidderEmailSender.new(auction).perform

        expect(AuctionMailer).to have_received(:losing_bidder_notification)
          .with(bidder: losing_bidder, auction: auction).once
        expect(AuctionMailer).not_to have_received(:losing_bidder_notification)
          .with(bidder: winning_bidder, auction: auction)
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
