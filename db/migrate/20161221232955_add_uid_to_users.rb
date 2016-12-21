class AddUidToUsers < ActiveRecord::Migration
  def change
   add_column :users, :uid, :string, default: '', null: false
   add_index :users, :uid
  end
end
