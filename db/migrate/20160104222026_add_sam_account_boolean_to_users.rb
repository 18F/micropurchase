class AddSamAccountBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sam_account, :boolean, default: false, null: false
    add_index :users, :sam_account
  end
end
