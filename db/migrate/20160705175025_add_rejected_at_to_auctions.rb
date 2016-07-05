class AddRejectedAtToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :rejected_at, :datetime
  end
end
