require 'rails_helper'

describe MarkAuctionAsPaid do
  describe '#perform' do
    context 'for default pcard auctions' do
      it 'should set paid_at to a time and c2_status to paid' do
        auction = create(:auction, :payment_needed)
        expect(auction.paid_at).to be_nil

        MarkAuctionAsPaid.new(auction: auction).perform

        expect(auction.paid_at).to_not be_nil
        expect(auction.c2_status).to eq('c2_paid')
      end

      it 'sends the right email to the vendor for default pcard auctions' do
        customer = create(:customer)

        auction = create(
          :auction,
          :payment_needed
        )
        mailer_double = double(deliver_later: true)
        allow(WinningBidderMailer).to receive(:auction_paid_default_pcard)
          .with(auction: auction)
          .and_return(mailer_double)

        MarkAuctionAsPaid.new(auction: auction).perform

        expect(WinningBidderMailer).to have_received(:auction_paid_default_pcard)
          .with(auction: auction)
        expect(mailer_double).to have_received(:deliver_later)
      end
    end

    context 'for other pcard auctions' do
      it 'should set paid_at to a time and leave c2_status unchanged' do
        auction = create(:auction, :payment_needed, purchase_card: :other)
        expect(auction.paid_at).to be_nil
        c2_status = auction.c2_status

        MarkAuctionAsPaid.new(auction: auction).perform

        expect(auction.paid_at).to_not be_nil
        expect(auction.c2_status).to eq(c2_status)
      end

      it 'sends the right email to the vendor for other pcard auctions' do
        customer = create(:customer)

        auction = create(
          :auction,
          :payment_needed,
          purchase_card: :other,
          customer: customer
        )
        mailer_double = double(deliver_later: true)
        allow(WinningBidderMailer).to receive(:auction_paid_other_pcard)
          .with(auction: auction)
          .and_return(mailer_double)

        MarkAuctionAsPaid.new(auction: auction).perform

        expect(WinningBidderMailer).to have_received(:auction_paid_other_pcard)
          .with(auction: auction)
        expect(mailer_double).to have_received(:deliver_later)
      end
    end
  end
end
