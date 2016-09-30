require 'rails_helper'

describe ArchiveAuction do
  it 'should set the delivery_status to be archived' do
    auction = FactoryGirl.create(:auction, :unpublished)
    ArchiveAuction.new(auction: auction).perform

    expect(auction).to be_archived
    expect(auction.published).to eq("archived")
  end

  it 'should not be applied if the auction is published' do
    auction = FactoryGirl.create(:auction, :published)
    out = ArchiveAuction.new(auction: auction).perform

    expect(out).to be_falsey
    expect(auction).to_not be_archived
  end
end
