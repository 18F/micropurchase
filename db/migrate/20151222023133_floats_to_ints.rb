class FloatsToInts < ActiveRecord::Migration
  def change
    change_column :auctions, :start_price, :integer, default: 3500
    change_column :bids, :amount, :integer
  end
end
