class ChangeAuctionFieldsToHaveStatusInTheName < ActiveRecord::Migration
  def change
    rename_column :auctions, :delivered, :delivery_status
    rename_column :auctions, :awardee_paid, :awardee_paid_status
  end
end
