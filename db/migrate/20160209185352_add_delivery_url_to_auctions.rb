class AddDeliveryUrlToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :delivery_url, :string
  end
end
