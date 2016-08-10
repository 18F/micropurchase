require 'rails_helper'

describe C2StatusPresenter::Sent do
  describe '#status' do
    it 'returns the status for sent' do
      presenter = C2StatusPresenter::Sent.new

      expect(presenter.status)
        .to eq(I18n.t('statuses.c2_presenter.sent.status'))
    end
  end

  describe '#body' do
    it 'returns the body for sent' do
      presenter = C2StatusPresenter::Sent.new

      expect(presenter.body)
        .to eq(I18n.t('statuses.c2_presenter.sent.body'))
    end
  end

  describe '#header' do
    it 'returns the header for sent' do
      presenter = C2StatusPresenter::Sent.new

      expect(presenter.header)
        .to eq(I18n.t('statuses.c2_presenter.sent.header'))
    end
  end
end
