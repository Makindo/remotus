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

ActiveRecord::Schema.define(version: 20131220185352) do

  create_table "genders", force: true do |t|
    t.integer  "value"
    t.float    "confidence", default: 0.0
    t.string   "type"
    t.text     "data"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genders", ["person_id"], name: "index_genders_on_person_id"

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
    t.integer  "radius",      default: 0
  end

  add_index "geolocations", ["city", "state", "country", "person_id"], name: "index_geolocations_on_city_and_state_and_country_and_person_id", unique: true
  add_index "geolocations", ["person_id"], name: "index_geolocations_on_person_id"
  add_index "geolocations", ["source_id", "source_type"], name: "index_geolocations_on_source_id_and_source_type"

  create_table "names", force: true do |t|
    t.string   "personal",   default: ""
    t.string   "middle",     default: ""
    t.string   "family",     default: ""
    t.integer  "person_id"
    t.string   "type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "names", ["person_id"], name: "index_names_on_person_id"
  add_index "names", ["personal", "family", "type", "person_id"], name: "index_names_on_personal_and_family_and_type_and_person_id", unique: true

  create_table "profiles", force: true do |t|
    t.integer  "person_id"
    t.string   "external_id",                 null: false
    t.string   "type",                        null: false
    t.text     "data",                        null: false
    t.string   "location"
    t.string   "name"
    t.string   "username"
    t.boolean  "exists",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["exists"], name: "index_profiles_on_exists"
  add_index "profiles", ["external_id", "type"], name: "index_profiles_on_external_id_and_type", unique: true
  add_index "profiles", ["person_id"], name: "index_profiles_on_person_id"

  create_table "searches", force: true do |t|
    t.string   "query",                     null: false
    t.string   "type",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
    t.integer  "account_id"
  end

  add_index "searches", ["account_id"], name: "index_searches_on_account_id"
  add_index "searches", ["query", "type"], name: "index_searches_on_query_and_type", unique: true

  create_table "searches_statuses", id: false, force: true do |t|
    t.integer "search_id", null: false
    t.integer "status_id", null: false
  end

  create_table "statuses", force: true do |t|
    t.integer  "profile_id"
    t.string   "external_id",                 null: false
    t.text     "text",                        null: false
    t.string   "type",                        null: false
    t.text     "data",                        null: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "exists",      default: false
    t.float    "positive",    default: 0.0
    t.float    "negative",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["exists"], name: "index_statuses_on_exists"
  add_index "statuses", ["external_id", "type"], name: "index_statuses_on_external_id_and_type", unique: true
  add_index "statuses", ["profile_id"], name: "index_statuses_on_profile_id"

  create_table "votes", force: true do |t|
    t.boolean  "value"
    t.integer  "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "search_id"
    t.integer  "account_id"
    t.integer  "rating"
  end

  add_index "votes", ["search_id", "status_id", "account_id"], name: "index_votes_on_search_id_and_status_id_and_account_id", unique: true
  add_index "votes", ["status_id"], name: "index_votes_on_status_id"

end
