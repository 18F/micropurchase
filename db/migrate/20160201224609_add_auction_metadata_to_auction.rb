class AddAuctionMetadataToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :delivery_deadline, :datetime
    add_column :auctions, :delivered_at, :datetime
    add_column :auctions, :awardee_paid_at, :datetime
    add_column :auctions, :notes, :text
  end
end
