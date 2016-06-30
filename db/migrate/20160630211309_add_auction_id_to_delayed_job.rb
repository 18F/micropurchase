class AddAuctionIdToDelayedJob < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :auction_id, :integer
  end
end
