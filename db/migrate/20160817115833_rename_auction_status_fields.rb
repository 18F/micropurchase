class RenameAuctionStatusFields < ActiveRecord::Migration
  def change
    rename_column :auctions, :c2_approval_status, :c2_status
    rename_column :auctions, :result, :status
  end
end
