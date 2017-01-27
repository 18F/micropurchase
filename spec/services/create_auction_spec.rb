require 'rails_helper'

describe CreateAuction do
  describe '#perform' do
    it 'returns an auction' do
      params = {
        auction: {
          title: 'hello'
        }
      }
      current_user = create(:user)
      create_auction = CreateAuction.new(params, current_user)
      auction = create_auction.perform

      expect(auction).to be_a Auction
    end

    context 'when the auction is valid' do
      let(:valid_auction_params) do
        {
          "title"=>"This is the form-edited title",
          "started_at"=>"2017-01-30",
          "started_at(1i)"=>"11",
          "started_at(2i)"=>"30",
          "started_at(3i)"=>"AM",
          "ended_at"=>"2017-01-30",
          "ended_at(1i)"=>"4",
          "ended_at(2i)"=>"45",
          "ended_at(3i)"=>"PM",
          "due_in_days"=>"6",
          "delivery_due_at"=>"2017-02-7",
          "start_price"=>"3500",
          "type"=>"sealed_bid",
          "summary"=>"The Summary!",
          "description"=>"and the admin related stuff",
          "skill_ids"=>[""],
          "github_repo"=>"https://github.com/18F/calc",
          "issue_url"=>"https://github.com/18F/calc/issues/255",
          "purchase_card"=>"default",
          "c2_status"=>"not_requested",
          "customer_id"=>"",
          "billable_to"=>"Client Account 1 (Billable)",
          "notes"=>""
        }
      end

      it 'saves the auction' do
        params = HashWithIndifferentAccess.new({
          auction: valid_auction_params,
          commit: "Create",
          controller: "admin/auctions",
          action: "create"
        })

        current_user = create(:user)

        create_auction = CreateAuction.new(params, current_user)

        expect {
          create_auction.perform
        }.to change { Auction.count }.by(1)
      end

      it "creates a published state of 'unpublished'" do
        params = HashWithIndifferentAccess.new({
          auction: valid_auction_params,
          commit: "Create",
          controller: "admin/auctions",
          action: "create"
        })

        current_user = create(:user)

        auction = CreateAuction.new(params, current_user).perform

        published_state = auction
                            .states
                            .find {|state| state.name == 'published'}

        expect(published_state.state_value).to eq('unpublished')
      end
    end

    context 'when the auction is not valid' do
      it 'does not save the auction' do
        params = {
          auction: {title: nil}
        }
        current_user = create(:user)

        create_auction = CreateAuction.new(params, current_user)

        expect {
          create_auction.perform
        }.to change { Auction.count }.by(0)
      end
    end
  end
end
