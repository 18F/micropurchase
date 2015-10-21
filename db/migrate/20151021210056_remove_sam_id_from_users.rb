class RemoveSamIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :sam_id
  end
end
