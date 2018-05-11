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

ActiveRecord::Schema.define(version: 20180511221035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.text "category_name"
    t.text "description"
    t.text "response_text"
    t.integer "assigned_to_id"
    t.integer "category_status_type_id"
    t.text "action_needed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_in_list"
    t.boolean "rule_change_made"
    t.integer "category_response_type_id"
    t.text "text_from_comments"
    t.text "notes"
    t.index "lower(category_name)", name: "index_categories_on_lowercase_category_name", unique: true
    t.index ["order_in_list"], name: "index_categories_on_order_in_list"
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

  create_table "change_log_entries", force: :cascade do |t|
    t.text "description"
    t.integer "comment_id"
    t.integer "category_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type"
    t.string "object_type"
    t.index ["category_id", "created_at"], name: "index_change_log_entries_on_category_id_and_created_at"
    t.index ["comment_id", "created_at"], name: "index_change_log_entries_on_comment_id_and_created_at"
    t.index ["created_at"], name: "index_change_log_entries_on_created_at"
    t.index ["user_id"], name: "index_change_log_entries_on_user_id"
  end

  create_table "comment_data_sources", force: :cascade do |t|
    t.string "data_source_name"
    t.string "description"
    t.string "comment_download_url"
    t.boolean "active"
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
    t.text "comment_text"
    t.string "attachment_url"
    t.text "summary"
    t.integer "comment_status_type_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_name"
    t.boolean "manually_entered"
    t.integer "order_in_list"
    t.integer "num_commenters"
    t.integer "comment_data_source_id"
    t.index ["comment_data_source_id"], name: "index_comments_on_comment_data_source_id"
    t.index ["order_in_list"], name: "index_comments_on_order_in_list"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.boolean "admin"
    t.boolean "active"
    t.boolean "read_only"
  end

  add_foreign_key "categories", "category_response_types", on_delete: :nullify
  add_foreign_key "categories", "category_status_types", on_delete: :restrict
  add_foreign_key "categories", "users", column: "assigned_to_id", on_delete: :nullify
  add_foreign_key "change_log_entries", "categories", on_delete: :nullify
  add_foreign_key "change_log_entries", "comments", on_delete: :nullify
  add_foreign_key "change_log_entries", "users", on_delete: :restrict
  add_foreign_key "comments", "comment_data_sources", on_delete: :cascade
  add_foreign_key "comments", "comment_status_types", on_delete: :restrict
end
