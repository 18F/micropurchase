class AddC2ApprovedAtToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :c2_approved_at, :datetime
  end
end
