require 'rails_helper'

describe C2StatusPresenter::Pending do
  describe '#status' do
    it 'returns the status for pending' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Pending.new(auction: auction)

      expect(presenter.status)
        .to eq(I18n.t('statuses.c2_presenter.pending.status'))
    end
  end

  describe '#body' do
    it 'returns the body for pending' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Pending.new(auction: auction)

      expect(presenter.body)
        .to eq(I18n.t('statuses.c2_presenter.pending.body',
                      link: presenter.link))
    end
  end

  describe '#header' do
    it 'returns the header for pending' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Pending.new(auction: auction)

      expect(presenter.header)
        .to eq(I18n.t('statuses.c2_presenter.pending.header'))
    end
  end
end
