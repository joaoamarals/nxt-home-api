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

ActiveRecord::Schema[7.0].define(version: 2023_12_08_155535) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "home_ads", force: :cascade do |t|
    t.string "uuid", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.jsonb "elements"
    t.index ["uuid"], name: "idx_16460_index_home_ads_on_uuid", unique: true
  end

  create_table "searches", force: :cascade do |t|
    t.string "location", limit: 255, null: false
    t.decimal "min_price", precision: 10
    t.decimal "max_price", precision: 10
    t.integer "rooms"
    t.bigint "user_id", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["user_id"], name: "idx_16470_index_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "idx_16475_index_users_on_email", unique: true
  end

  add_foreign_key "searches", "users"
end
