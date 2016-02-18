class RemovedDeliveredAtFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :delivered_at
  end
end
