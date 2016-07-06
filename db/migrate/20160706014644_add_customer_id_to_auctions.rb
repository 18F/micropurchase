class AddCustomerIdToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :customer_id, :integer
    add_index :auctions, :customer_id
  end
end
