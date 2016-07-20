require 'rails_helper'

describe Admin::CustomersController do
  describe '#index' do
    it 'returns a list of customers in alphabetical order' do
      user = create(:admin_user)
      customer1 = create(:customer, agency_name: 'XYZ')
      customer2 = create(:customer, agency_name: 'ABC')
      get :index, { }, user_id: user.id

      vm = assigns(:view_model)
      expect(vm.customers).to eq([customer2, customer1])
      expect(vm.customer_count).to eq(2)
    end
  end
end
