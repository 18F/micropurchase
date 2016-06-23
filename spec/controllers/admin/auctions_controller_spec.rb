require 'rails_helper'

describe Admin::AuctionsController do
  describe '#show' do
    it 'assigns presented auction' do
      user = create(:admin_user)
      auction_record = create(:auction)
      get :show, { id: auction_record.id }, user_id: user.id
      auction = assigns(:view_model)
      expect(auction.auction).to eq(auction_record)
    end
  end

  describe '#update' do
    context 'when the params are invalid' do
      it 'assigns the un-updated auction and renders edit' do
        user = create(:admin_user)
        auction_record = create(:auction)

        update_auction_double = double
        allow(update_auction_double).to receive(:perform)
          .and_return(false)
        allow(UpdateAuction).to receive(:new)
          .with(any_args)
          .and_return(update_auction_double)

        params = {
          id: auction_record.id,
          auction: {
            title: 'new title'
          }
        }

        put :update, params, user_id: user.id
        auction = assigns(:view_model)

        expect(auction.record.id).to eq(auction_record.id)
        expect(controller).to render_template :edit
      end
    end
  end
end
