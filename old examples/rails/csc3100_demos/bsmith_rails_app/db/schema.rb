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

ActiveRecord::Schema.define(version: 20170325192325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "owner"
    t.string   "course_number"
    t.string   "course_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["owner"], name: "index_courses_on_owner", using: :btree
  end

  create_table "honors_and_awards", force: :cascade do |t|
    t.integer  "owner"
    t.string   "honor_date"
    t.string   "honor_name"
    t.string   "honor_description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "references", force: :cascade do |t|
    t.integer  "owner"
    t.string   "reference_name"
    t.string   "reference_contact_info"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "skills_and_interests", force: :cascade do |t|
    t.integer  "owner"
    t.string   "skill_name"
    t.string   "skill_description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "major"
    t.string   "degree_program"
    t.string   "department"
    t.integer  "year_started"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "work_experiences", force: :cascade do |t|
    t.integer  "owner"
    t.string   "start_date"
    t.string   "end_date"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
