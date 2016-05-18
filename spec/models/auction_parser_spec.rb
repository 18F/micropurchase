require 'rails_helper'

RSpec.describe AuctionParser do

  describe '#perform' do
    context 'attributes in params' do
      it 'assigns attributes correctly' do
        user = create(:user)
        params = {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            issue_url: 'issue url'
          }
        }

        attributes = AuctionParser.new(params, user).attributes

        expect(attributes[:title]).to eq(params[:auction][:title])
        expect(attributes[:description]).to eq(params[:auction][:description])
        expect(attributes[:github_repo]).to eq(params[:auction][:github_repo])
        expect(attributes[:issue_url]).to eq(params[:auction][:issue_url])
      end
    end

    context 'attributes that require parsing' do
      it 'parses attributes correctly' do
        user = create(:user)
        params = {
          auction:  {
            'start_datetime(1i)' => '2016',
            'start_datetime(2i)' => '04',
            'start_datetime(3i)' => '15',
            'start_datetime(4i)' => '13',
            'start_datetime(5i)' => '00',
          }
        }

        attributes = AuctionParser.new(params, user).attributes

        expect(attributes[:start_datetime]).to be_a(ActiveSupport::TimeWithZone)
      end
    end
  end
end
