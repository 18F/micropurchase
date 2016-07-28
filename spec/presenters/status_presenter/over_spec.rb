require 'rails_helper'

describe StatusPresenter::Over do
  describe '#tag_data_value_status' do
    it 'is closed' do
      presenter = StatusPresenter::Over.new(auction)
      expect(presenter.tag_data_value_status).to eq('Closed')
    end
  end

  describe '#tag_data_label_2' do
    it 'has a label about the winning bid amount' do
      presenter = StatusPresenter::Over.new(auction)
      expect(presenter.tag_data_label_2).to eq('Winning Bid')
    end
  end

  describe '#tag_data_value_2' do
    it 'returns winning bid amount' do
      presenter = StatusPresenter::Over.new(auction)
      expect(presenter.tag_data_value_2).to eq('$3,000.00')
    end
  end

  describe '#relative_time' do
    it 'returns date that auction ended' do
      time = Time.local(2008, 9, 1)
      auction = create(:auction, :closed, ended_at: time)

      presenter = StatusPresenter::Over.new(auction)

      expect(presenter.relative_time).to eq 'Ended on: 09/01/2008'
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :closed,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
