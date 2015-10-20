class RebuildTheOldSchema < ActiveRecord::Migration
  def change
    create_table "auctions" do |t|
      t.string   "issue_url"
      t.float    "start_price"
      t.datetime "start_datetime"
      t.datetime "end_datetime"
      t.string   "title"
      t.text     "description"
      t.string   "github_repo"
      t.integer  "published"
      t.datetime "created_at",     null: false
      t.datetime "updated_at",     null: false
    end

    create_table "bids" do |t|
      t.integer  "bidder_id"
      t.integer  "auction_id"
      t.float    "amount"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "users" do |t|
      t.string   "github_id"
      t.string   "duns_id"
      t.string   "sam_id"
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
