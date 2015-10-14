class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :issue_url
      t.float :start_price
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :title
      t.text :description
      t.string :github_repo
      t.integer :published
      t.timestamps null: false
    end
  end
end
