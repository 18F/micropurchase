require 'rails_helper'

RSpec.describe LoginsController, type: :controller do
  describe '#index' do
    it 'should render getting started instructions' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
