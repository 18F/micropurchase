require 'rails_helper'

describe AuctionAccepted do
  context 'the winning bidder lacks a credit card URL' do
    it 'does not call CreateCapProposalJob' do
      auction = create(
        :auction,
        :below_micropurchase_threshold,
        :winning_vendor_is_small_business,
        :delivery_due_at_expired
      )
      winning_bidder = WinningBid.new(auction).find.bidder
      winning_bidder.update(credit_card_form_url: "")

      allow(CreateCapProposalJob).to receive(:perform_later)
        .with(auction.id)
        .and_return(nil)

      AuctionAccepted.new(auction).perform

      expect(CreateCapProposalJob).not_to have_received(:perform_later)
    end

    it 'calls RequestCreditCardFormUrlEmailSender#perform' do
      auction = create(
        :auction,
        :below_micropurchase_threshold,
        :winning_vendor_is_small_business,
        :delivery_due_at_expired
      )

      winning_bidder = WinningBid.new(auction).find.bidder
      winning_bidder.update(credit_card_form_url: "")

      request_cc_form_url_double = instance_double(
        'RequestCreditCardFormUrlEmailSender'
      )
      allow(request_cc_form_url_double).to receive(:perform)
      allow(RequestCreditCardFormUrlEmailSender).to receive(:new)
        .with(auction)
        .and_return(request_cc_form_url_double)

      AuctionAccepted.new(auction).perform

      expect(request_cc_form_url_double).to have_received(:perform)
    end
  end

  context 'auction is below the micropurchase threshold' do
    it 'calls the CreateCapProposalJob' do
      auction = create(
        :auction,
        :below_micropurchase_threshold,
        :winning_vendor_is_small_business,
        :delivery_due_at_expired
      )
      allow(CreateCapProposalJob).to receive(:perform_later)
        .with(auction.id)
        .and_return(nil)

      AuctionAccepted.new(auction).perform

      expect(CreateCapProposalJob).to have_received(:perform_later).with(auction.id)
    end
  end

  context 'auction is between micropurchase and SAT threshold' do
    context 'winning vendor is a small business' do
      it 'calls the CreateCapProposalJob' do
        auction = create(
          :auction,
          :between_micropurchase_and_sat_threshold,
          :winning_vendor_is_small_business,
          :delivery_due_at_expired
        )
        allow(CreateCapProposalJob).to receive(:perform_later)
          .with(auction.id)
          .and_return(nil)

        AuctionAccepted.new(auction).perform

        expect(CreateCapProposalJob).to have_received(:perform_later).with(auction.id)
      end
    end

    context 'winning vendor is not a small business' do
      it 'does not call the CreateCapProposalJob' do
        auction = create(
          :auction,
          :between_micropurchase_and_sat_threshold,
          :winning_vendor_is_non_small_business,
          :delivery_due_at_expired
        )
        allow(CreateCapProposalJob).to receive(:perform_later)
          .with(auction.id)
          .and_return(nil)

        AuctionAccepted.new(auction).perform

        expect(CreateCapProposalJob).to_not have_received(:perform_later).with(auction.id)
      end
    end
  end

  context 'auction is for another purchase card' do
    it 'does not call CreateCapProposalJob' do
      auction = create(
        :auction,
        :below_micropurchase_threshold,
        :winning_vendor_is_small_business,
        :delivery_due_at_expired,
        purchase_card: :other
      )
      allow(CreateCapProposalJob).to receive(:perform_later)
        .with(auction.id)

      AuctionAccepted.new(auction).perform

      expect(CreateCapProposalJob).not_to have_received(:perform_later)
    end
  end
end
