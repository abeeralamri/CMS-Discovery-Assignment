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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_142256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "content_items", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "language_code", default: "ar", null: false
    t.integer "duration_seconds"
    t.datetime "published_at"
    t.integer "status", default: 1, null: false
    t.string "audio_video_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id", "status", "published_at"], name: "index_content_items_on_program_id_and_status_and_published_at"
    t.index ["program_id"], name: "index_content_items_on_program_id"
    t.index ["published_at"], name: "index_content_items_on_published_at"
  end

  create_table "content_types", force: :cascade do |t|
    t.string "ar_name", null: false
    t.string "en_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ar_name"], name: "index_content_types_on_ar_name"
    t.index ["en_name"], name: "index_content_types_on_en_name"
  end

  create_table "programs", force: :cascade do |t|
    t.bigint "content_type_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "language_code", default: "ar", null: false
    t.integer "status", default: 1, null: false
    t.datetime "published_at"
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_type_id"], name: "index_programs_on_content_type_id"
    t.index ["language_code"], name: "index_programs_on_language_code"
    t.index ["published_at"], name: "index_programs_on_published_at"
  end

  add_foreign_key "content_items", "programs"
end
