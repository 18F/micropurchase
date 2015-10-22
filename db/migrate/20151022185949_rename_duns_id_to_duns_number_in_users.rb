class RenameDunsIdToDunsNumberInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :duns_id, :duns_number
  end
end
