require 'rails_helper'

describe C2StatusPresenter::Approved do
  describe '#status' do
    it 'returns the status for approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Approved.new(auction: auction)

      expect(presenter.status)
        .to eq(I18n.t('statuses.c2_presenter.approved.status'))
    end
  end

  describe '#body' do
    it 'returns the body for approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Approved.new(auction: auction)

      expect(presenter.body).to eq(
        I18n.t('statuses.c2_presenter.approved.body', link: presenter.link)
      )
    end
  end

  describe '#header' do
    it 'returns the header for approved' do
      auction = create(:auction)
      presenter = C2StatusPresenter::Approved.new(auction: auction)

      expect(presenter.header).to eq(
        I18n.t('statuses.c2_presenter.approved.header')
      )
    end
  end
end
