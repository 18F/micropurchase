class AddPurchaseCardToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :purchase_card, :integer, null: false, default: 0
  end
end
