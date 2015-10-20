require 'rails_helper'

RSpec.describe Admins do
  let(:admins) { Admins.new }

  it '.github_ids is an array of data that is pulled from the right file' do
    expect(Admins.github_ids).to include(2471)
  end

  it '#verify? return true when the uid is includes in the .github_ids' do
    expect(admins.verify?(2471)).to eq(true)
  end

  it '#verify? works when passed a string that matches' do
    expect(admins.verify?('2471')).to eq(true)
  end

  it '#verify? return false when the uid is not included in the github_ids' do
    expect(admins.verify?(1)).to eq(false)
  end

  it '.verify? is an easy convenience that takes away the mess of calling .new' do
    expect(Admins.verify?('2471')).to eq(true)
    expect(Admins.verify?(1)).to eq(false)
  end
end
