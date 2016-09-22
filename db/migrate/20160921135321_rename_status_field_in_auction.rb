class RenameStatusFieldInAuction < ActiveRecord::Migration
  def change
    rename_column :auctions, :status, :delivery_status
  end
end
