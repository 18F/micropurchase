class AddDeliveredToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :delivered, :integer, default: 0
  end
end
