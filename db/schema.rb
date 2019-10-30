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

ActiveRecord::Schema.define(version: 2019_10_30_042355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "languages" because of following StandardError
#   Unknown type 'regconfig' for column 'language'

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "doc_text"
    t.tsvector "doc_text_vector"
    t.index ["doc_text_vector"], name: "doc_text_idx", using: :gin
  end

  create_table "terms", force: :cascade do |t|
    t.string "name"
    t.integer "count"
    t.bigint "page_id"
    t.index ["name"], name: "index_terms_on_name"
    t.index ["page_id"], name: "index_terms_on_page_id"
  end

end
