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

ActiveRecord::Schema.define(version: 20150814162016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string  "name"
    t.integer "roster_count_id"
  end

  create_table "player_scores", force: :cascade do |t|
    t.integer "teams"
    t.integer "player_id"
    t.integer "week_id"
    t.decimal "points",    precision: 5, scale: 2
    t.boolean "starter"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "postiion"
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
  end

  create_table "teams", force: :cascade do |t|
    t.string  "name"
    t.integer "league_id"
  end

  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer "year"
    t.integer "week_number"
  end

  add_foreign_key "leagues", "roster_counts"
  add_foreign_key "player_scores", "weeks"
end
