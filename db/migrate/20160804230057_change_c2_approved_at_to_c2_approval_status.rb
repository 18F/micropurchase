class ChangeC2ApprovedAtToC2ApprovalStatus < ActiveRecord::Migration
  def up
    add_column :auctions, :c2_approval_status, :integer, null: false, default: 0

    # 0 no c2 proposal
    # 1 no c2 proposal, was requested
    # 2 c2 proposal, not approved
    # 3 c2 proposal, approved

    execute <<-SQL
      UPDATE auctions
      SET c2_approval_status = 0
      WHERE c2_approved_at IS NULL
      AND c2_proposal_url = '';
    SQL

    execute <<-SQL
      UPDATE auctions
      SET c2_approval_status = 2
      WHERE c2_approved_at IS NULL
      AND c2_proposal_url != '';
    SQL

    execute <<-SQL
      UPDATE auctions
      SET c2_approval_status = 3
      WHERE c2_approved_at IS NOT NULL
      AND c2_proposal_url != '';
    SQL

    remove_column :auctions, :c2_approved_at
  end

  def down
    add_column :auctions, :c2_approved_at, :datetime
    remove_column :auctions, :c2_approval_status, :datetime
  end
end
