require 'rails_helper'

describe BidPresenter do
  describe 'equality' do
    let(:bid) { create(:bid) }
    let(:bid2) { create(:bid) }

    specify { expect(BidPresenter.new(bid)).to eq(BidPresenter.new(bid)) }
    specify { expect(BidPresenter.new(bid)).to_not eq(BidPresenter.new(bid2)) }
  end
end
