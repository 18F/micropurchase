class AddNullFalseToAuctionFields < ActiveRecord::Migration
  def up
    change_column :auctions, :billable_to, :string, default: ''
    change_column :auctions, :cap_proposal_url, :string, default: ''
    change_column :auctions, :description, :text, default: ''
    change_column :auctions, :github_repo, :string, default: ''
    change_column :auctions, :issue_url, :string, default: ''
    change_column :auctions, :notes, :text, default: ''
    change_column :auctions, :summary, :text, default: ''

    change_column_null :auctions, :title, false, ''
    change_column_null :auctions, :summary, false
    change_column_null :auctions, :description, false
    change_column_null :auctions, :start_price, false
  end

  def down
    change_column :auctions, :billable_to, :string, default: nil
    change_column :auctions, :cap_proposal_url, :string, default: nil
    change_column :auctions, :description, :text, default: nil
    change_column :auctions, :github_repo, :string, default: nil
    change_column :auctions, :issue_url, :string, default: nil
    change_column :auctions, :notes, :text, default: nil
    change_column :auctions, :summary, :text, default: nil

    change_column_null :auctions, :title, true
    change_column_null :auctions, :summary, true
    change_column_null :auctions, :description, true
    change_column_null :auctions, :delivery_deadline, true
    change_column_null :auctions, :start_price, true
  end
end
