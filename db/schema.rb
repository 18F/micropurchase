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

ActiveRecord::Schema.define(version: 20161221232955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: :cascade do |t|
    t.string   "issue_url",       default: ""
    t.integer  "start_price",     default: 3500, null: false
    t.datetime "started_at",                     null: false
    t.datetime "ended_at",                       null: false
    t.string   "title",                          null: false
    t.text     "description",     default: "",   null: false
    t.string   "github_repo",     default: ""
    t.integer  "published",       default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "summary",         default: "",   null: false
    t.datetime "delivery_due_at",                null: false
    t.text     "notes",           default: ""
    t.string   "billable_to",     default: ""
    t.integer  "delivery_status", default: 0
    t.integer  "type",            default: 0
    t.string   "delivery_url"
    t.string   "c2_proposal_url", default: ""
    t.integer  "user_id"
    t.integer  "purchase_card",   default: 0,    null: false
    t.datetime "paid_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.integer  "customer_id"
    t.integer  "c2_status",       default: 0,    null: false
    t.string   "token"
  end

  add_index "auctions", ["customer_id"], name: "index_auctions_on_customer_id", using: :btree
  add_index "auctions", ["delivery_status"], name: "index_auctions_on_delivery_status", using: :btree
  add_index "auctions", ["token"], name: "index_auctions_on_token", unique: true, using: :btree
  add_index "auctions", ["user_id"], name: "index_auctions_on_user_id", using: :btree

  create_table "auctions_skills", id: false, force: :cascade do |t|
    t.integer "auction_id", null: false
    t.integer "skill_id",   null: false
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "bidder_id",  null: false
    t.integer  "auction_id", null: false
    t.integer  "amount",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "via"
  end

  add_index "bids", ["auction_id"], name: "index_bids_on_auction_id", using: :btree
  add_index "bids", ["bidder_id"], name: "index_bids_on_bidder_id", using: :btree

  create_table "client_accounts", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",                       null: false
    t.boolean  "billable",                   null: false
    t.integer  "tock_id",                    null: false
    t.boolean  "active",     default: false
  end

  add_index "client_accounts", ["tock_id"], name: "index_client_accounts_on_tock_id", unique: true, using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "agency_name",  null: false
    t.string   "contact_name"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "auction_id"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "insight_metrics", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "statistic",                    null: false
    t.string   "label",                        null: false
    t.string   "name",                         null: false
    t.string   "href",            default: "", null: false
    t.string   "label_statistic", default: "", null: false
  end

  add_index "insight_metrics", ["name"], name: "index_insight_metrics_on_name", using: :btree

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "github_id"
    t.string   "duns_number",         default: "",    null: false
    t.string   "name",                default: "",    null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email"
    t.string   "github_login"
    t.string   "payment_url",         default: "",    null: false
    t.integer  "sam_status",          default: 0,     null: false
    t.boolean  "contracting_officer", default: false, null: false
    t.boolean  "small_business",      default: false, null: false
    t.string   "uid",                 default: "",    null: false
  end

  add_index "users", ["contracting_officer"], name: "index_users_on_contracting_officer", where: "(contracting_officer = true)", using: :btree
  add_index "users", ["sam_status"], name: "index_users_on_sam_status", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
