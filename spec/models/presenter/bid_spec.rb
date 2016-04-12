require 'rails_helper'

RSpec.describe Presenter::Bid, type: :model do
  describe 'equality' do
    let(:bid) { FactoryGirl.create(:bid) }
    let(:bid2) { FactoryGirl.create(:bid) }

    specify { expect(Presenter::Bid.new(bid)).to eq(Presenter::Bid.new(bid)) }
    specify { expect(Presenter::Bid.new(bid)).to_not eq(Presenter::Bid.new(bid2)) }
    specify { expect(Presenter::Bid.new(bid)).to_not eq(bid) }
  end
end
