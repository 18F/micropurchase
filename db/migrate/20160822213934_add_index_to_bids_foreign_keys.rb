class AddIndexToBidsForeignKeys < ActiveRecord::Migration
  def change
    change_column_null :bids, :bidder_id, false
    change_column_null :bids, :auction_id, false
    add_index :bids, :bidder_id
    add_index :bids, :auction_id
  end
end
