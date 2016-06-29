require 'rails_helper'

describe Customer do
  describe 'Validations' do
    it { should validate_presence_of(:agency_name) }
  end
end
