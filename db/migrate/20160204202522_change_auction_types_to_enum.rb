class ChangeAuctionTypesToEnum < ActiveRecord::Migration
  def change
    remove_column :auctions, :type
    add_column :auctions, :type, :integer, default: 0
  end
end
