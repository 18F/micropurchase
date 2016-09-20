class AddActiveToClientAccount < ActiveRecord::Migration
  def change
    add_column :client_accounts, :active, :boolean
  end
end
