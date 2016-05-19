class AddSubmitMethodToBids < ActiveRecord::Migration
  def change
    add_column :bids, :via, :string
  end
end
