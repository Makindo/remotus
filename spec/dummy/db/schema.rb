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

ActiveRecord::Schema.define(version: 20130910184921) do

  create_table "geolocations", force: true do |t|
    t.text     "data"
    t.text     "query"
    t.string   "type"
    t.integer  "person_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.string   "city",        default: ""
    t.string   "state",       default: ""
    t.string   "country",     default: ""
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "geolocations", ["city", "state", "country"], name: "index_geolocations_on_city_and_state_and_country", unique: true
  add_index "geolocations", ["person_id"], name: "index_geolocations_on_person_id"
  add_index "geolocations", ["source_id", "source_type"], name: "index_geolocations_on_source_id_and_source_type"

  create_table "profiles", force: true do |t|
    t.integer "person_id"
    t.string  "external_id",                 null: false
    t.string  "type",                        null: false
    t.text    "data",                        null: false
    t.string  "location"
    t.string  "name"
    t.string  "username"
    t.boolean "gone",        default: false
  end

  add_index "profiles", ["external_id", "type"], name: "index_profiles_on_external_id_and_type", unique: true
  add_index "profiles", ["gone"], name: "index_profiles_on_gone"
  add_index "profiles", ["person_id"], name: "index_profiles_on_person_id"

  create_table "searches", force: true do |t|
    t.string   "query",      null: false
    t.string   "type",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["query", "type"], name: "index_searches_on_query_and_type", unique: true

  create_table "searches_statuses", id: false, force: true do |t|
    t.integer "search_id", null: false
    t.integer "status_id", null: false
  end

  add_index "searches_statuses", ["search_id"], name: "index_searches_statuses_on_search_id"
  add_index "searches_statuses", ["status_id"], name: "index_searches_statuses_on_status_id"

  create_table "statuses", force: true do |t|
    t.integer  "profile_id"
    t.string   "external_id",                 null: false
    t.text     "text",                        null: false
    t.string   "type",                        null: false
    t.text     "data",                        null: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gone",        default: false
    t.float    "positive",    default: 0.0
    t.float    "negative",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["external_id", "type"], name: "index_statuses_on_external_id_and_type", unique: true
  add_index "statuses", ["gone"], name: "index_statuses_on_gone"
  add_index "statuses", ["profile_id"], name: "index_statuses_on_profile_id"

end
