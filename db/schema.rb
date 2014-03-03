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

ActiveRecord::Schema.define(version: 20140303232313) do

  create_table "activity_logs", force: true do |t|
    t.integer  "developer_id"
    t.integer  "project_id"
    t.datetime "when"
    t.integer  "task_id"
    t.integer  "activity_type", default: 0
  end

  create_table "developers", force: true do |t|
    t.string   "name"
    t.string   "loginid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "gh_personal_token"
    t.string   "gh_username"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "status",      default: 0
    t.date     "began"
    t.date     "finished"
    t.integer  "priority",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.text     "description"
    t.string   "gh_repo_url"
    t.date     "due"
  end

  create_table "tasks", force: true do |t|
    t.string   "description"
    t.integer  "developer_id"
    t.integer  "project_id"
    t.datetime "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "due"
    t.string   "link"
    t.integer  "priority"
    t.integer  "difficulty"
    t.integer  "duration"
    t.string   "gh_issue_number"
  end

  create_table "users", force: true do |t|
    t.string   "loginid"
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "developer_id"
    t.datetime "logged_in_at"
  end

end
