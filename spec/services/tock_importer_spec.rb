require 'rails_helper'

describe TockImporter do
  it 'creates or updates tock projects' do
    TockImporter.new.perform

    expect(ClientAccount.count).to eq 3

    TockImporter.new.perform

    expect(ClientAccount.count).to eq 3
  end
end
