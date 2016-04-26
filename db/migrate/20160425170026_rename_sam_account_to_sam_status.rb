class RenameSamAccountToSamStatus < ActiveRecord::Migration
  def up
    add_column :users, :sam_status, :integer, null: false, default: 0

    execute <<-SQL
      UPDATE users
      SET sam_status = 1
      WHERE sam_account IS TRUE;
      UPDATE users
      SET sam_status = 2
      WHERE sam_account IS FALSE;
    SQL

    add_index :users, :sam_status
    remove_column :users, :sam_account, :boolean
  end

  def down
    add_column :users, :sam_account, :boolean, default: false, null: false

    execute <<-SQL
      UPDATE users
      SET sam_account = TRUE
      WHERE sam_status = 1;
      UPDATE users
      SET sam_account = FALSE
      WHERE sam_status = 2;
    SQL

    remove_column :users, :sam_status, :integer
  end
end
