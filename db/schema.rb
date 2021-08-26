# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_25_024245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "athletes", force: :cascade do |t|
    t.string "name"
    t.integer "height"
    t.boolean "gender"
    t.integer "weight"
    t.integer "userid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_athletes_on_discard"
    t.index ["gender"], name: "index_athletes_on_gender"
  end

  create_table "competitors", force: :cascade do |t|
    t.integer "race_id"
    t.integer "athlete_id"
    t.integer "team_id"
    t.boolean "lane"
    t.string "result"
    t.string "seed"
    t.string "place"
    t.index ["athlete_id"], name: "index_competitors_on_athlete_id"
    t.index ["lane"], name: "index_competitors_on_lane"
    t.index ["place"], name: "index_competitors_on_place"
    t.index ["race_id"], name: "index_competitors_on_race_id"
    t.index ["team_id"], name: "index_competitors_on_team_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_levels_on_discard"
  end

  create_table "meets", force: :cascade do |t|
    t.boolean "paid"
    t.string "name"
    t.integer "owner_id"
    t.datetime "meet_date"
    t.integer "season_id"
    t.integer "stadium_id"
    t.text "points"
    t.string "sponsor"
    t.boolean "ppl", default: false
    t.boolean "evt", default: false
    t.boolean "sch", default: false
    t.string "meet_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_meets_on_discard"
    t.index ["meet_key"], name: "index_meets_on_meet_key", unique: true
    t.index ["owner_id"], name: "index_meets_on_owner_id"
  end

  create_table "race_types", force: :cascade do |t|
    t.string "name"
    t.boolean "gender", default: false
    t.boolean "athlete_team", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_race_types_on_discard"
    t.index ["name"], name: "index_race_types_on_name", unique: true
  end

  create_table "races", force: :cascade do |t|
    t.integer "meet_id"
    t.integer "race_type"
    t.boolean "schedule"
    t.boolean "event"
    t.boolean "round"
    t.boolean "heat"
    t.time "start"
    t.decimal "wind", precision: 4, scale: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_races_on_discard"
    t.index ["meet_id", "event", "round", "heat"], name: "meet_event_round_heat", unique: true
    t.index ["meet_id"], name: "index_races_on_meet_id"
    t.index ["race_type"], name: "index_races_on_race_type"
  end

  create_table "seasons", force: :cascade do |t|
    t.date "season"
    t.boolean "state_id"
    t.integer "country_id"
    t.integer "classification_id"
    t.boolean "level_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_seasons_on_discard"
  end

  create_table "stadiums", force: :cascade do |t|
    t.string "name"
    t.string "google_name"
    t.text "address"
    t.string "city"
    t.integer "state_id"
    t.integer "zip"
    t.integer "country_id"
    t.decimal "lat", precision: 11, scale: 7
    t.decimal "lng", precision: 11, scale: 7
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_stadiums_on_discard"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.string "timezone"
    t.integer "country_id"
    t.decimal "lat", precision: 11, scale: 7
    t.decimal "lng", precision: 11, scale: 7
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_states_on_discard"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.boolean "state_id"
    t.integer "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discard"
    t.index ["discard"], name: "index_teams_on_discard"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
