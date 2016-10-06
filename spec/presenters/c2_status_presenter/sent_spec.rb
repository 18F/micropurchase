require 'rails_helper'

describe C2StatusPresenter::Sent do
  describe '#body' do
    it 'returns the body for sent' do
      auction = build(:auction)
      presenter = C2StatusPresenter::Sent.new(auction: auction)

      expect(presenter.body)
        .to eq(I18n.t('statuses.c2_presenter.sent.body'))
    end
  end

  describe '#header' do
    it 'returns the header for sent' do
      auction = build(:auction)
      presenter = C2StatusPresenter::Sent.new(auction: auction)

      expect(presenter.header)
        .to eq(I18n.t('statuses.c2_presenter.sent.header'))
    end
  end
end
