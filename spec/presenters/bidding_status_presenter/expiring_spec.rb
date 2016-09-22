require 'rails_helper'

describe BiddingStatusPresenter::Expiring do
  describe '#label_class' do
    it 'returns the correct label class' do
      auction = build(:auction)

      presenter = BiddingStatusPresenter::Expiring.new(auction)

      expect(presenter.label_class).to eq 'auction-label-expiring'
    end
  end

  describe '#label' do
    it 'returns the correct label' do
      auction = build(:auction)

      presenter = BiddingStatusPresenter::Expiring.new(auction)

      expect(presenter.label).to eq 'Expiring'
    end
  end
end
