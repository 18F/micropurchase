class AddSmallBizFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :small_business, :boolean, default: false, null: false
  end
end
