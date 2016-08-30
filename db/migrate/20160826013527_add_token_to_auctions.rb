class AddTokenToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :token, :string
    add_index :auctions, :token, unique: true
  end
end
