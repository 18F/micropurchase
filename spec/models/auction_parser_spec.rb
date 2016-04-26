require 'rails_helper'

RSpec.describe AuctionParser do
  let(:parser) { AuctionParser.new(params) }
  let(:auction) { parser.auction }
  let(:attributes) { parser.attributes }

  describe '#perform' do
    context 'when the price is too high' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_price: 3500.01
          }
        }
      end

      it 'drops the price down to the bid upper limit' do
        expect(attributes[:start_price]).to eq(3500.00)
      end
    end

    context 'when the price is too low' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_price: 0
          }
        }
      end

      it 'bumps the price to the bid upper limit' do
        expect(attributes[:start_price]).to eq(3500.00)
      end
    end

    context 'when the price is not present' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
          }
        }
      end

      it 'makes the price the bid upper limit' do
        expect(attributes[:start_price]).to eq(3500.00)
      end
    end

    context 'with other data' do
      let(:params) do
        {
          title: 'title',
          description: 'description',
          github_repo: 'github url',
          issue_url: 'issue url'
        }
      end

      it 'stores the right stuff' do
        expect(attributes[:title]).to eq(params[:title])
        expect(attributes[:description]).to eq(params[:description])
        expect(attributes[:github_repo]).to eq(params[:github_repo])
        expect(attributes[:issue_url]).to eq(params[:issue_url])
      end
    end
  end
end
