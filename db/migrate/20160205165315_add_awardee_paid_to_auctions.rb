class AddAwardeePaidToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :awardee_paid, :integer, default: 0
  end
end
