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

    branding_account = ClientAccount.where(tock_id: 120).first
    edu_account = ClientAccount.where(tock_id: 97).first
    guides_account = ClientAccount.where(tock_id: 96).first

    expect(branding_account).to be_active
    expect(edu_account).to be_active
    expect(guides_account).to_not be_active
  end
end
