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

ActiveRecord::Schema.define(version: 20141205060627) do

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.string   "location"
    t.string   "gender"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id"

  create_table "groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["organization_id"], name: "index_groups_on_organization_id"
  add_index "groups", ["user_id"], name: "index_groups_on_user_id"

  create_table "organizations", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id"

  create_table "schedules", force: true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "group_id"
    t.integer  "repeat_setting_id"
    t.string   "title"
    t.text     "note"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["group_id"], name: "index_schedules_on_group_id"
  add_index "schedules", ["organization_id"], name: "index_schedules_on_organization_id"
  add_index "schedules", ["repeat_setting_id"], name: "index_schedules_on_repeat_setting_id"
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "email"
    t.boolean  "admin_flag",          default: false
    t.string   "last_login_provider"
    t.datetime "last_login_at"
    t.text     "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
