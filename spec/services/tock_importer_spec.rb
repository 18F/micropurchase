require 'rails_helper'

describe TockImporter do
  it 'creates or updates tock projects' do
    TockImporter.new.perform

    expect(ClientAccount.count).to eq 3

    TockImporter.new.perform

    expect(ClientAccount.count).to eq 3
  end

  it "saves the 'active' field in ClientAccount" do
    TockImporter.new.perform

    client_account = ClientAccount.first

    expect(client_account).to respond_to(:active)
  end
end
