class ChangeBidderToUser < ActiveRecord::Migration
  def change
    rename_table :bidders, :users
  end
end
