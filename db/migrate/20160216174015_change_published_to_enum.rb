class ChangePublishedToEnum < ActiveRecord::Migration
  def change
    change_column :auctions, :published, :integer, default: 0
  end
end
