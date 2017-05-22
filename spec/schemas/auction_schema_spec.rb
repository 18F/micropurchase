require 'rails_helper'

RSpec.describe "Validate JSON schemas" do
  include JsonSchemaHelper

  it "auction.json" do
    auction = FactoryGirl.create(:auction)
    auction_hash = JSON.parse(auction.to_json)
    puts auction_hash.pretty_inspect
    errors = JSON::Validator.fully_validate(
      schema_file('auction'), 
      { auction: auction_hash }, 
      validate_schema: true
    )
    expect(errors).to eq([])
  end
end
