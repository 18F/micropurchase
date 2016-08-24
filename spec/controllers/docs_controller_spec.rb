require 'rails_helper'

describe DocsController do
  render_views

  describe '#index' do
    it 'should render the Swagger docs' do
      get :index
      expect(assigns(:swagger)).to_not be_nil
      expect(response).to render_template("index")
    end
  end
end
