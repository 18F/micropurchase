class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :agency_name, null: false
      t.string :contact_name
      t.string :email

      t.timestamps null: false
    end
  end
end
