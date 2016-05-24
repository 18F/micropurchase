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

ActiveRecord::Schema.define(version: 20160520191158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auctions", force: :cascade do |t|
    t.string   "issue_url",           default: ""
    t.integer  "start_price",         default: 3500, null: false
    t.datetime "started_at",                         null: false
    t.datetime "ended_at",                           null: false
    t.string   "title",                              null: false
    t.text     "description",         default: "",   null: false
    t.string   "github_repo",         default: ""
    t.integer  "published",           default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "summary",             default: "",   null: false
    t.datetime "delivery_due_at"
    t.text     "notes",               default: ""
    t.string   "billable_to",         default: ""
    t.integer  "result",              default: 0
    t.integer  "type",                default: 0
    t.integer  "awardee_paid_status", default: 0
    t.string   "delivery_url"
    t.string   "cap_proposal_url",    default: ""
    t.integer  "user_id"
  end

  add_index "auctions", ["user_id"], name: "index_auctions_on_user_id", using: :btree

  create_table "bids", force: :cascade do |t|
    t.integer  "bidder_id"
    t.integer  "auction_id"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "via"
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
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "github_id"
    t.string   "duns_number"
    t.string   "name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email"
    t.string   "credit_card_form_url"
    t.string   "github_login"
    t.integer  "sam_status",           default: 0,     null: false
    t.boolean  "contracting_officer",  default: false, null: false
    t.boolean  "small_business",       default: false, null: false
  end

  add_index "users", ["contracting_officer"], name: "index_users_on_contracting_officer", where: "(contracting_officer = true)", using: :btree
  add_index "users", ["sam_status"], name: "index_users_on_sam_status", using: :btree

end
