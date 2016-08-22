require 'rails_helper'

describe Admin::NeedsAttentionAuctionListItem do
  describe '#c2_proposal_url' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal URL' do
        auction = create(:auction, purchase_card: :default)

        view_model = Admin::NeedsAttentionAuctionListItem.new(auction)

        expect(view_model.c2_proposal_url).to eq auction.c2_proposal_url
      end
    end

    context 'auction for other purchase card' do
      it 'returns n/a' do
        auction = create(:auction, purchase_card: :other)

        view_model = Admin::NeedsAttentionAuctionListItem.new(auction)

        expect(view_model.c2_proposal_url).to eq 'N/A'
      end
    end
  end

  describe '#payment_status' do
    context 'winning bidder has a payment url' do
      it 'is pending' do
        auction = create(:auction)
        user = create(:user, payment_url: 'http://example.com')
        winning_bid = double(find: double(decorated_bidder: user))
        allow(WinningBid).to receive(:new).with(auction).and_return(winning_bid)

        payment_status = Admin::NeedsAttentionAuctionListItem.new(auction).payment_status

        expect(payment_status).to eq(
          I18n.t('needs_attention.list_item.payment_status.pending')
        )
      end
    end

    context 'winning bidder does not have a payment url' do
      it 'needs credit card url' do
        auction = create(:auction)
        user = create(:user, payment_url: '')
        winning_bid = double(find: double(decorated_bidder: user))
        allow(WinningBid).to receive(:new).with(auction).and_return(winning_bid)

        payment_status = Admin::NeedsAttentionAuctionListItem.new(auction).payment_status

        expect(payment_status).to eq(
          I18n.t('needs_attention.list_item.payment_status.needs_credit_card_url')
        )
      end
    end
  end
end
