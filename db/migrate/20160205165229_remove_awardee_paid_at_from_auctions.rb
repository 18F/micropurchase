class RemoveAwardeePaidAtFromAuctions < ActiveRecord::Migration
  def change
    remove_column :auctions, :awardee_paid_at
  end
end
