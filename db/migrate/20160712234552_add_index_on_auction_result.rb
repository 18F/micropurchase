class AddIndexOnAuctionResult < ActiveRecord::Migration
  def change
    add_index :auctions, :result
  end
end
