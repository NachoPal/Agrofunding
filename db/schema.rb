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

ActiveRecord::Schema.define(version: 20150519102202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "farmlands", force: true do |t|
    t.string   "country"
    t.string   "community"
    t.string   "municipality"
    t.string   "region"
    t.string   "product"
    t.float    "price"
    t.boolean  "eco"
    t.integer  "farmer_id"
    t.string   "usage"
    t.date     "period_start"
    t.date     "period_end"
    t.float    "geom_area"
    t.float    "rating"
    t.integer  "num_agrofunders"
    t.json     "geom_json"
    t.spatial  "lonlat",          limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  add_index "farmlands", ["farmer_id"], :name => "index_farmlands_on_farmer_id"
  add_index "farmlands", ["lonlat"], :name => "index_farmlands_on_lonlat", :spatial => true

  create_table "fundings", force: true do |t|
    t.integer  "user_id"
    t.integer  "farmland_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fundings", ["farmland_id"], :name => "index_fundings_on_farmland_id"
  add_index "fundings", ["user_id"], :name => "index_fundings_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "surname"
    t.string   "community"
    t.string   "municipality"
    t.string   "city"
    t.string   "address"
    t.string   "postal_code"
    t.string   "telephone"
    t.string   "company"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "description"
    t.string   "website"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
