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

ActiveRecord::Schema.define(version: 20160305204337) do

  create_table "password_recovery_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "password_recovery_tokens", ["user_id"], name: "index_password_recovery_tokens_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lastfm_username"
    t.boolean  "send_weekly_email",     default: true
    t.text     "last_email_contents"
    t.boolean  "public_chart"
    t.string   "slug"
    t.datetime "last_email_updated_at"
  end

end
