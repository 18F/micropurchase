class AddDefaultStartPriceToAuctions < ActiveRecord::Migration
  def change
    change_column :auctions, :start_price, :float, default: 3500.0
  end
end
