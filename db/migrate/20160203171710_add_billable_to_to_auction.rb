class AddBillableToToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :billable_to, :string
  end
end
