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
            'started_at' => '2016-04-15',
            'started_at(1i)' => '13',
            'started_at(2i)' => '00',
            'started_at(3i)' => 'PM',
          }
        }

        attributes = AuctionParser.new(params, user).attributes

        expect(attributes[:started_at]).to be_a(DateTime)
      end
    end
  end
end
