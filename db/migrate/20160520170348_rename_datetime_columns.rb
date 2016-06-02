class RenameDatetimeColumns < ActiveRecord::Migration
  def change
    rename_column :auctions, :start_datetime, :started_at
    rename_column :auctions, :end_datetime, :ended_at
    rename_column :auctions, :delivery_deadline, :delivered_at
  end
end
