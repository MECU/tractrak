# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_04_28_231234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "athletes", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "height"
    t.boolean "gender"
    t.integer "weight"
    t.integer "userid"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_athletes_on_discarded_at"
    t.index ["first_name"], name: "index_athletes_on_first_name"
    t.index ["gender"], name: "index_athletes_on_gender"
    t.index ["last_name"], name: "index_athletes_on_last_name"
  end

  create_table "careers", force: :cascade do |t|
    t.integer "athlete_id"
    t.integer "team_id"
    t.boolean "current"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["athlete_id"], name: "index_careers_on_athlete_id"
    t.index ["discarded_at"], name: "index_careers_on_discarded_at"
    t.index ["team_id"], name: "index_careers_on_team_id"
  end

  create_table "competitors", force: :cascade do |t|
    t.integer "race_id"
    t.integer "athlete_id"
    t.integer "team_id"
    t.integer "lane"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_levels_on_discarded_at"
  end

  create_table "meets", force: :cascade do |t|
    t.boolean "paid"
    t.string "name"
    t.integer "owner_id"
    t.datetime "meet_date", precision: nil
    t.integer "season_id"
    t.integer "stadium_id"
    t.jsonb "points"
    t.string "sponsor"
    t.string "time_zone"
    t.boolean "ppl", default: false
    t.boolean "evt", default: false
    t.boolean "sch", default: false
    t.string "meet_key"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_meets_on_discarded_at"
    t.index ["meet_key"], name: "index_meets_on_meet_key", unique: true
    t.index ["owner_id"], name: "index_meets_on_owner_id"
  end

  create_table "race_types", force: :cascade do |t|
    t.string "name"
    t.boolean "gender", default: false
    t.boolean "athlete_team", default: false
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_race_types_on_discarded_at"
    t.index ["name"], name: "index_race_types_on_name", unique: true
  end

  create_table "races", force: :cascade do |t|
    t.integer "meet_id"
    t.integer "race_type_id"
    t.integer "schedule"
    t.integer "event"
    t.integer "round"
    t.integer "heat"
    t.time "start"
    t.decimal "wind", precision: 4, scale: 2
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_races_on_discarded_at"
    t.index ["meet_id", "event", "round", "heat"], name: "meet_event_round_heat", unique: true
    t.index ["meet_id"], name: "index_races_on_meet_id"
    t.index ["race_type_id"], name: "index_races_on_race_type_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.date "season"
    t.integer "state_id"
    t.integer "country_id"
    t.integer "classification_id"
    t.integer "level_id"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_seasons_on_discarded_at"
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
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_stadiums_on_discarded_at"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.string "timezone"
    t.integer "country_id"
    t.decimal "lat", precision: 11, scale: 7
    t.decimal "lng", precision: 11, scale: 7
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_states_on_discarded_at"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.integer "state_id"
    t.integer "country_id"
    t.datetime "discarded_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_teams_on_discarded_at"
    t.index ["name"], name: "index_teams_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
