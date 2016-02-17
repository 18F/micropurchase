class AddAuctionTypes < ActiveRecord::Migration
  def change
    add_column :auctions, :type, :string
  end
end
