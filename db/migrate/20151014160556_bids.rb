class Bids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :bidder
      t.references :auction
      t.float :amount
      t.timestamps null: false
    end
  end
end
