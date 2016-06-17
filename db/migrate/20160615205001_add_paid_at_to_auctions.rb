class AddPaidAtToAuctions < ActiveRecord::Migration
  def up
    add_column :auctions, :paid_at, :datetime

    execute <<-SQL
      UPDATE auctions
      SET paid_at = CURRENT_TIMESTAMP
      WHERE awardee_paid_status = 1;
    SQL

    remove_column :auctions, :awardee_paid_status
  end

  def down
    add_column :auctions, :awardee_paid_status, :integer, default: 0

    execute <<-SQL
      UPDATE auctions
      SET awardee_paid_status = 1
      WHERE paid_at != NULL;
    SQL
    remove_column :auctions, :paid_at, :datetime
  end
end
