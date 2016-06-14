class AddUniquenessIndexToTockId < ActiveRecord::Migration
  def change
    add_index :client_accounts, :tock_id, unique: true
  end
end
