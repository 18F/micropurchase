require 'rails_helper'

describe Admin::DraftListItem do
  describe '#c2_proposal_status' do
    context 'auction for default purchase card' do
      it 'returns c2 proposal status' do
        Auction.c2_statuses.each do |status|
          status_string = status[0]
          auction = create(:auction, purchase_card: :default, c2_status: status_string)

          view_model = Admin::DraftListItem.new(auction)

          expect(view_model.c2_proposal_status).to eq(
            I18n.t("drafts.c2_status.#{status_string}.status")
          )
        end
      end
    end

    context 'auction for other purchase card' do
      it 'returns n/a' do
        auction = create(:auction, purchase_card: :other)

        view_model = Admin::DraftListItem.new(auction)

        expect(view_model.c2_proposal_status).to eq 'N/A'
      end
    end
  end
end
