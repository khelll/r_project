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

ActiveRecord::Schema.define(version: 20141001113624) do

  create_table "package_versions", force: true do |t|
    t.string   "package_name"
    t.string   "code"
    t.datetime "published_at"
    t.text     "title"
    t.text     "description"
    t.text     "authors"
    t.text     "maintainers"
    t.integer  "latest",       default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "package_versions", ["package_name", "code"], name: "index_package_versions_on_package_name_and_code", unique: true

end
