require 'rails_helper'

describe WinnersController do
  describe '#index' do
    it 'renders the winners dashboard page' do
      get :index
      expect(response.code).to eq '200'
    end
  end
end
