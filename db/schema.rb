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

ActiveRecord::Schema.define(version: 20180110013942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "category_name"
    t.string "description"
    t.string "response_text"
    t.integer "assigned_to_id"
    t.integer "category_status_type_id"
    t.string "action_needed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_in_list"
    t.boolean "rule_change_made"
    t.integer "category_response_type_id"
  end

  create_table "categories_comments", id: false, force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "category_response_types", force: :cascade do |t|
    t.string "response_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_status_types", force: :cascade do |t|
    t.string "status_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_status_types", force: :cascade do |t|
    t.string "status_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "source_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "organization"
    t.string "state"
    t.string "comment_text"
    t.string "attachment_url"
    t.string "summary"
    t.integer "comment_status_type_id"
    t.string "status_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_name"
    t.boolean "manually_entered"
    t.integer "order_in_list"
    t.integer "num_commenters"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.boolean "admin"
  end

end
