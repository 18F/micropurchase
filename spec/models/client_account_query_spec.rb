require 'rails_helper'

describe ClientAccountQuery do
  describe '#active' do
    it 'only returns active client accounts' do
      active = create(:client_account, active: true)
      _not_active = create(:client_account, active: false)

      client_accounts = ClientAccountQuery.new.active

      expect(client_accounts.length).to eq(1)
      expect(client_accounts.first.id).to eq(active.id)
      expect(client_accounts.first).to be_active
    end
  end
end
