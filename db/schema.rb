# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160216174015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: :cascade do |t|
    t.string   "issue_url"
    t.integer  "start_price",         default: 3500
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string   "title"
    t.text     "description"
    t.string   "github_repo"
    t.integer  "published",           default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "summary"
    t.datetime "delivery_deadline"
    t.text     "notes"
    t.string   "billable_to"
    t.integer  "result",              default: 0
    t.integer  "type",                default: 0
    t.integer  "awardee_paid_status", default: 0
    t.string   "delivery_url"
    t.string   "cap_proposal_url"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "bidder_id"
    t.integer  "auction_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "github_id"
    t.string   "duns_number"
    t.string   "name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email"
    t.boolean  "sam_account",          default: false, null: false
    t.string   "github_login"
    t.string   "credit_card_form_url"
  end

  add_index "users", ["sam_account"], name: "index_users_on_sam_account", using: :btree

end
