require 'rails_helper'

RSpec.describe AuctionParser do
  let(:parser) { AuctionParser.new(params) }
  let(:auction) { parser.auction }
  let(:attributes) { parser.attributes }

  describe '#perform' do
    context 'when an exact time is passed for start/end time' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015 15:15',
            end_datetime: '11/10/2015 2:15pm'
          }
        }
      end

      it 'uses the time and date' do
        expect(attributes[:start_datetime].utc.to_s)
          .to eq(Time.parse('Nov 3, 2015 15:15 EST').utc.to_s)
        expect(attributes[:end_datetime].utc.to_s)
          .to eq(Time.parse("Nov 10, 2015 14:15 EST").utc.to_s)
      end
    end

    context 'when only a date is passed for start/end time' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015'
          }
        }
      end

      it 'uses the time and date' do
        expect(attributes[:start_datetime].utc.to_s).to eq(Time.parse('Nov 3, 2015 0:00 EST').utc.to_s)
        expect(attributes[:end_datetime].utc.to_s).to eq(Time.parse("Nov 10, 2015 0:00 EST").utc.to_s)
      end
    end

    context 'when the start or end date is missing' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: '',
            end_datetime: ''
          }
        }
      end

      it 'raise an error' do
        expect { attributes }.to raise_error(ArgumentError)
      end
    end

    context 'with other data' do
      let(:params) do
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015',
            issue_url: 'issue url'
          }
        }
      end

      it 'stores the right stuff' do
        expect(attributes[:title]).to eq(params[:auction][:title])
        expect(attributes[:description]).to eq(params[:auction][:description])
        expect(attributes[:github_repo]).to eq(params[:auction][:github_repo])
        expect(attributes[:issue_url]).to eq(params[:auction][:issue_url])
      end
    end
  end
end
