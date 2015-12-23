class AddSummaryToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :summary, :text
  end
end
