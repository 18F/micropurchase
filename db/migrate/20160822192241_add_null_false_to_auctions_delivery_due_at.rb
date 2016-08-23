class AddNullFalseToAuctionsDeliveryDueAt < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE auctions
      SET delivery_due_at = CURRENT_TIMESTAMP
      WHERE delivery_due_at IS NULL;
    SQL

    change_column_null :auctions, :delivery_due_at, false
  end

  def down
    change_column_null :auctions, :delivery_due_at, true
  end
end
