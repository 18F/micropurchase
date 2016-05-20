class RenameDeliveredAtToDeliveryDueAt < ActiveRecord::Migration
  def change
    rename_column :auctions, :delivered_at, :delivery_due_at
  end
end
