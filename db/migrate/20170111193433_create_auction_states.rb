class CreateAuctionStates < ActiveRecord::Migration
  def change
    create_table :auction_states do |t|
      t.integer :auction_id
      t.string :state_value
      t.string :name
    end
  end
end
