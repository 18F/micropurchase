class AddNullFalseToStartDatetimeAndEndDatetime < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE auctions
      SET end_datetime = CURRENT_TIMESTAMP
      WHERE end_datetime IS NULL;
      UPDATE auctions
      SET start_datetime = CURRENT_TIMESTAMP
      WHERE start_datetime IS NULL;
    SQL

    change_column_null :auctions, :end_datetime, false
    change_column_null :auctions, :start_datetime, false
  end

  def down
    change_column_null :auctions, :end_datetime, true
    change_column_null :auctions, :start_datetime, true
  end
end
