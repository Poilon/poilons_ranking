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

ActiveRecord::Schema.define(version: 20150317180340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "character_participants", force: :cascade do |t|
    t.integer "participant_id"
    t.integer "character_id"
    t.integer "rank"
  end

  create_table "characters", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "game_id"
    t.string  "slug",    limit: 255
  end

  create_table "games", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       limit: 255
  end

  create_table "participants", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.float    "score"
    t.string   "location",         limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.string   "country",          limit: 255
    t.string   "state",            limit: 255
    t.string   "sub_state",        limit: 255
    t.string   "city",             limit: 255
    t.string   "slug",             limit: 255
    t.string   "twitter",          limit: 255
    t.string   "youtube",          limit: 255
    t.string   "wiki",             limit: 255
    t.string   "characters_index"
    t.string   "teams_index"
  end

  add_index "participants", ["game_id"], name: "index_participants_on_game_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.integer  "participant_id"
    t.integer  "tournament_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_participants", force: :cascade do |t|
    t.integer "team_id"
    t.integer "participant_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "game_id"
    t.string  "slug",    limit: 255
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "multiplier"
    t.integer  "game_id"
    t.integer  "remote_id"
    t.integer  "total_participants"
    t.string   "slug",               limit: 255
    t.datetime "date"
  end

end
