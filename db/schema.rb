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

ActiveRecord::Schema[7.0].define(version: 2022_11_02_192538) do
  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "team_id"
    t.index ["team_id"], name: "index_articles_on_team_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "year_1"
    t.integer "year_2"
    t.integer "year_3"
    t.integer "year_4"
    t.integer "year_5"
    t.integer "year_6"
    t.integer "player_option"
    t.integer "team_option"
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "two_way"
    t.boolean "waived"
    t.integer "team_id"
    t.index ["player_id"], name: "index_contracts_on_player_id"
    t.index ["team_id"], name: "index_contracts_on_team_id"
  end

  create_table "discord_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "username"
    t.string "image"
    t.string "token"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_discord_accounts_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "age"
    t.string "school"
    t.string "country"
    t.integer "years_in_league"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "draft_class"
    t.string "position"
    t.string "height"
    t.string "suffix"
    t.string "full_name"
    t.index ["age", "last_name"], name: "index_players_on_age_and_last_name"
    t.index ["height", "last_name"], name: "index_players_on_height_and_last_name"
    t.index ["last_name"], name: "index_players_on_last_name"
    t.index ["position", "last_name"], name: "index_players_on_position_and_last_name"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "city"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "articles", "teams"
  add_foreign_key "comments", "articles"
  add_foreign_key "contracts", "players"
  add_foreign_key "contracts", "teams"
  add_foreign_key "discord_accounts", "users"
  add_foreign_key "players", "teams"
end
