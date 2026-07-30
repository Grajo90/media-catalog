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

ActiveRecord::Schema[8.1].define(version: 2026_07_30_111838) do
  create_table "episodes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.string "original_title", null: false
    t.integer "season_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["season_id", "number"], name: "index_episodes_on_season_id_and_number", unique: true
    t.index ["season_id"], name: "index_episodes_on_season_id"
  end

  create_table "list_items", force: :cascade do |t|
    t.integer "content_id", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.integer "list_id", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["content_type", "content_id"], name: "index_list_items_on_content"
    t.index ["list_id", "position"], name: "index_list_items_on_list_id_and_position", unique: true
    t.index ["list_id"], name: "index_list_items_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "original_title", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.string "original_title", null: false
    t.string "title", null: false
    t.integer "tv_show_id", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
    t.index ["tv_show_id", "number"], name: "index_seasons_on_tv_show_id_and_number", unique: true
    t.index ["tv_show_id"], name: "index_seasons_on_tv_show_id"
  end

  create_table "tv_shows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "original_title", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "year", null: false
  end

  add_foreign_key "episodes", "seasons"
  add_foreign_key "list_items", "lists"
  add_foreign_key "seasons", "tv_shows"
end
