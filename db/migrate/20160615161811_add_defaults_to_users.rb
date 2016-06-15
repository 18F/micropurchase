class AddDefaultsToUsers < ActiveRecord::Migration
  def up
    change_column :users, :duns_number, :string, null: false, default: ""
    change_column :users, :name, :string, null: false, default: ""
    change_column :users, :credit_card_form_url, :string, null: false, default: ""
  end

  def down
    change_column :users, :duns_number, :string, null: true, default: nil
    change_column :users, :name, :string, null: true, default: nil
    change_column :users, :credit_card_form_url, :string, null: true, default: nil
  end
end
