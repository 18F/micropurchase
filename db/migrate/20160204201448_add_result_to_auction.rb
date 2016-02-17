class AddResultToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :result, :integer, default: 0
  end
end
