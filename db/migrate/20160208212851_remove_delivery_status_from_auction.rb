class RemoveDeliveryStatusFromAuction < ActiveRecord::Migration
  def change
    remove_column :auctions, :delivery_status
  end
end
