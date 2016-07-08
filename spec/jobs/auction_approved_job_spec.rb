require 'rails_helper'

describe AuctionApprovedJob do
  describe '#perform' do
    it 'calls the AuctionAcceptedEmailSender' do
      auction = create(:auction)
      email_double = double(perform: true)
      allow(AuctionAcceptedEmailSender).to receive(:new)
        .with(auction)
        .and_return(email_double)

      AuctionApprovedJob.new.perform(auction.id)

      expect(email_double).to have_received(:perform)
    end
  end
end
