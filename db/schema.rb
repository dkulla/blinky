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

ActiveRecord::Schema.define(version: 8) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instructions", force: true do |t|
    t.integer  "sequence_id"
    t.integer  "number"
    t.text     "phrase"
    t.integer  "effects"
    t.string   "color"
    t.string   "background_color"
    t.float    "fade_time"
    t.float    "tempo"
    t.float    "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", force: true do |t|
    t.integer  "number"
    t.text     "segment_order"
    t.integer  "sign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letters", ["sign_id"], name: "index_letters_on_sign_id", using: :btree

  create_table "segments", force: true do |t|
    t.integer "length"
    t.integer "number"
    t.integer "letter_id"
  end

  add_index "segments", ["letter_id"], name: "index_segments_on_letter_id", using: :btree

  create_table "signs", force: true do |t|
    t.text     "phrase"
    t.text     "letter_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "effects"
    t.string   "color"
    t.string   "background_color"
    t.float    "fade_time"
    t.float    "tempo"
  end

  add_index "signs", ["effects"], name: "index_signs_on_effects", using: :btree

end
