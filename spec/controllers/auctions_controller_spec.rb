require 'rails_helper'

RSpec.describe AuctionsController, controller: true do
  describe '#index' do
    it 'should render the list of auctions' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end

