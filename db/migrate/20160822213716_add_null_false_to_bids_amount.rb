class AddNullFalseToBidsAmount < ActiveRecord::Migration
  def up
    execute <<-SQL
       UPDATE bids
       SET amount = 0
       WHERE amount IS NULL;
    SQL

    change_column_null :bids, :amount, false
  end

  def down
    change_column_null :bids, :amount, true
  end
end
