class CreateClientAccounts < ActiveRecord::Migration
  def change
    create_table :client_accounts do |t|
      t.timestamps null: false
      t.string :name, null: false
      t.boolean :billable, null: false
      t.integer :tock_id, null: false
    end
  end
end
