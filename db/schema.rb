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

ActiveRecord::Schema.define(version: 2020_02_29_002722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "change_log_entries", force: :cascade do |t|
    t.text "description"
    t.integer "comment_id"
    t.integer "suggested_change_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type"
    t.string "object_type"
    t.integer "rulemaking_id"
    t.index ["rulemaking_id", "comment_id", "created_at"], name: "index_cle_on_rulemaking_and_comment_and_created_at"
    t.index ["rulemaking_id", "created_at"], name: "index_change_log_entries_on_rulemaking_id_and_created_at"
    t.index ["rulemaking_id", "suggested_change_id", "created_at"], name: "index_cle_on_rulemaking_and_suggested_change_and_created_at"
    t.index ["rulemaking_id", "user_id"], name: "index_change_log_entries_on_rulemaking_id_and_user_id"
  end

  create_table "comment_data_sources", force: :cascade do |t|
    t.string "data_source_name"
    t.string "description"
    t.string "comment_download_url"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rulemaking_id"
  end

  create_table "comment_status_types", force: :cascade do |t|
    t.string "status_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rulemaking_id"
    t.string "color_name"
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
    t.integer "rulemaking_id"
    t.index ["rulemaking_id", "comment_data_source_id"], name: "index_comments_on_rulemaking_id_and_comment_data_source_id"
    t.index ["rulemaking_id", "order_in_list"], name: "index_comments_on_rulemaking_id_and_order_in_list"
  end

  create_table "comments_suggested_changes", id: false, force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.bigint "suggested_change_id", null: false
  end

  create_table "rulemakings", force: :cascade do |t|
    t.string "rulemaking_name"
    t.string "agency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_push_import"
  end

  create_table "suggested_change_response_types", force: :cascade do |t|
    t.string "response_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rulemaking_id"
    t.string "color_name"
  end

  create_table "suggested_change_status_types", force: :cascade do |t|
    t.string "status_text"
    t.integer "order_in_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rulemaking_id"
    t.string "color_name"
  end

  create_table "suggested_changes", force: :cascade do |t|
    t.text "suggested_change_name"
    t.text "description"
    t.text "response_text"
    t.integer "assigned_to_id"
    t.integer "suggested_change_status_type_id"
    t.text "action_needed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_in_list"
    t.boolean "rule_change_made"
    t.integer "suggested_change_response_type_id"
    t.text "text_from_comments"
    t.text "notes"
    t.integer "rulemaking_id"
    t.index "rulemaking_id, lower(suggested_change_name)", name: "index_suggested_changes_on_rulemaking_and_suggested_change_name", unique: true
    t.index ["rulemaking_id", "order_in_list"], name: "index_suggested_changes_on_rulemaking_id_and_order_in_list"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.boolean "admin"
    t.boolean "read_only"
    t.integer "user_id"
    t.integer "rulemaking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.boolean "application_admin"
    t.boolean "active"
    t.integer "last_rulemaking_viewed_id"
    t.string "reset_password_token"
    t.datetime "password_reset_sent_at"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "change_log_entries", "comments", on_delete: :nullify
  add_foreign_key "change_log_entries", "rulemakings", on_delete: :cascade
  add_foreign_key "change_log_entries", "suggested_changes", on_delete: :nullify
  add_foreign_key "change_log_entries", "users", on_delete: :restrict
  add_foreign_key "comment_data_sources", "rulemakings", on_delete: :cascade
  add_foreign_key "comment_status_types", "rulemakings", on_delete: :cascade
  add_foreign_key "comments", "comment_data_sources", on_delete: :nullify
  add_foreign_key "comments", "comment_status_types", on_delete: :restrict
  add_foreign_key "comments", "rulemakings", on_delete: :cascade
  add_foreign_key "suggested_change_response_types", "rulemakings", on_delete: :cascade
  add_foreign_key "suggested_change_status_types", "rulemakings", on_delete: :cascade
  add_foreign_key "suggested_changes", "rulemakings", on_delete: :cascade
  add_foreign_key "suggested_changes", "suggested_change_response_types", on_delete: :nullify
  add_foreign_key "suggested_changes", "suggested_change_status_types", on_delete: :restrict
  add_foreign_key "suggested_changes", "users", column: "assigned_to_id", on_delete: :nullify
  add_foreign_key "user_permissions", "rulemakings", on_delete: :cascade
  add_foreign_key "user_permissions", "users", on_delete: :cascade
end
