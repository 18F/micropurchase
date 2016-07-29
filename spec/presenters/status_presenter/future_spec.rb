require 'rails_helper'

describe StatusPresenter::Future do
  describe '#tag_data_value_status' do
    it "returns human readable time" do
      presenter = StatusPresenter::Future.new(auction)
      expect(presenter.tag_data_value_status).to eq("in 3 days")
    end
  end

  describe '#tag_data_label_2' do
    it "returns starting bid" do
      presenter = StatusPresenter::Future.new(auction)
      expect(presenter.tag_data_label_2).to eq("Starting bid")
    end
  end

  describe '#tag_data_value_2' do
    it "returns start price" do
      presenter = StatusPresenter::Future.new(auction)
      expect(presenter.tag_data_value_2).to eq("$3,500.00")
    end
  end

  describe '#relative_time' do
    it 'returns time until auction starts' do
      Timecop.freeze do
        time = Time.current + 1.day
        auction = create(:auction, :future, started_at: time)

        presenter = StatusPresenter::Future.new(auction)

        expect(presenter.relative_time).to eq 'Starting in 1 day'
      end
    end
  end

  def auction
    @_auction ||= create(
      :auction,
      :future,
      started_at: Time.now + 3.days,
      start_price: 3500,
      bids: [create(:bid, amount: 3000)]
    )
  end
end
