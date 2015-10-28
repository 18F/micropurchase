require 'rails_helper'

RSpec.describe AdminCreateAuction do
  let(:creator) { AdminCreateAuction.new(params) }
  let(:auction) { creator.auction }

  describe '#perform' do
    context 'when the price is too high' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015',
            start_price: 3500.01
          }
        }
      }

      it 'drops the price down to the bid upper limit' do
        creator.perform
        expect(auction.start_price).to eq(3400.99)
      end
    end

    context 'when the price is too low' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015',
            start_price: 0
          }
        }
      }

      it 'bumps the price to the bid upper limit' do
        creator.perform
        expect(auction.start_price).to eq(3400.99)
      end
    end

    context 'when the price is not present' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015',
          }
        }
      }

      it 'makes the price the bid upper limit' do
        creator.perform
        expect(auction.start_price).to eq(3400.99)
      end
    end

    context 'when an exact time is passed for start/end time' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015 15:15',
            end_datetime: '11/10/2015 2:15pm',
          }
        }
      }

      it 'uses the time and date' do
        creator.perform
        expect(auction.start_datetime.utc.to_s).to  eq(Time.parse('Nov 3, 2015 15:15 EST').utc.to_s)
        expect(auction.end_datetime.utc.to_s).to    eq(Time.parse("Nov 10, 2015 14:15 EST").utc.to_s)
      end
    end

    context 'when only a date is passed for start/end time' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: 'Nov 3, 2015',
            end_datetime: '11/10/2015',
          }
        }
      }

      it 'uses the time and date' do
        creator.perform
        expect(auction.start_datetime.utc.to_s).to eq(Time.parse('Nov 3, 2015 0:00 EST').utc.to_s)
        expect(auction.end_datetime.utc.to_s).to   eq(Time.parse("Nov 10, 2015 0:00 EST").utc.to_s)
      end
    end

    context 'when the start or end date is missing' do
      let(:params) {
        {
          auction: {
            title: 'title',
            description: 'description',
            github_repo: 'github url',
            start_datetime: '',
            end_datetime: '',
          }
        }
      }

      it 'raise an error' do
        expect {
          creator.perform
        }.to raise_error(ArgumentError)
      end
    end

    context 'with other data' do
      let(:params) {
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
      }

      it 'stores the right stuff' do
        creator.perform
        expect(auction.title).to eq(params[:auction][:title])
        expect(auction.description).to eq(params[:auction][:description])
        expect(auction.github_repo).to eq(params[:auction][:github_repo])
        expect(auction.issue_url).to eq(params[:auction][:issue_url])
      end
    end
  end
end
