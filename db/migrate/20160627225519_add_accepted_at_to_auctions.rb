class AddAcceptedAtToAuctions < ActiveRecord::Migration
  def up
    add_column :auctions, :accepted_at, :datetime

    execute <<-SQL
      UPDATE auctions
      SET accepted_at = delivery_due_at;
    SQL
  end

  def down
    remove_column :auctions, :accepted_at
  end
end
