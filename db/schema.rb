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

ActiveRecord::Schema.define(version: 20150815210534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues_users", id: false, force: :cascade do |t|
    t.integer "user_id",   null: false
    t.integer "league_id", null: false
  end

  add_index "leagues_users", ["league_id"], name: "index_leagues_users_on_league_id", using: :btree
  add_index "leagues_users", ["user_id"], name: "index_leagues_users_on_user_id", using: :btree

  create_table "player_scores", force: :cascade do |t|
    t.integer "player_id"
    t.integer "week_id"
    t.decimal "points",    precision: 5, scale: 2
    t.boolean "starter"
    t.integer "team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "position"
  end

  create_table "roster_counts", force: :cascade do |t|
    t.integer "qb"
    t.integer "rb"
    t.integer "wr"
    t.integer "te"
    t.integer "k"
    t.integer "d_st"
    t.integer "lb"
    t.integer "dl"
    t.integer "db"
    t.integer "flex"
    t.integer "league_id"
    t.integer "year"
    t.integer "dt"
    t.integer "de"
    t.integer "cb"
    t.integer "s"
    t.integer "matchup_count"
  end

  add_index "roster_counts", ["league_id", "year"], name: "index_roster_counts_on_league_id_and_year", unique: true, using: :btree

  create_table "teams", force: :cascade do |t|
    t.string  "name"
    t.integer "league_id"
    t.integer "espn_id"
  end

  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "auth_token"
    t.string   "email",           null: false
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer "year"
    t.integer "number"
  end

  add_foreign_key "player_scores", "players"
  add_foreign_key "player_scores", "weeks"
end
