# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_03_005240) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bids", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.integer "bid_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_bids_on_post_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "event_inquiries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.string "email"
    t.string "subject"
    t.text "message"
    t.string "name"
    t.string "contributor_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_event_inquiries_on_post_id"
    t.index ["user_id"], name: "index_event_inquiries_on_user_id"
  end

  create_table "hammers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "bid_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "post_id"
    t.string "payment_history"
    t.index ["bid_id"], name: "index_hammers_on_bid_id"
    t.index ["post_id"], name: "index_hammers_on_post_id"
    t.index ["user_id"], name: "index_hammers_on_user_id"
  end

  create_table "inquiries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "email"
    t.string "subject"
    t.text "message"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inquiries_on_user_id"
  end

  create_table "post_tickets", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "festival_name"
    t.string "event_name"
    t.string "category"
    t.text "content"
    t.date "event_date"
    t.integer "count"
    t.integer "price"
    t.string "venue"
    t.integer "total_purchases"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_post_tickets_on_user_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "festival_name"
    t.string "event_name"
    t.string "category"
    t.text "content"
    t.date "event_date"
    t.string "venue"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "start_price"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "purchasing_quantities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "post_ticket_id", null: false
    t.bigint "user_id", null: false
    t.integer "count"
    t.string "payment_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_ticket_id"], name: "index_purchasing_quantities_on_post_ticket_id"
    t.index ["user_id"], name: "index_purchasing_quantities_on_user_id"
  end

  create_table "successful_bidder_limiteds", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "set_time"
    t.string "set_location"
    t.string "suspension"
    t.text "message"
    t.string "contact_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_successful_bidder_limiteds_on_post_id"
  end

  create_table "ticket_buyer_limiteds", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "post_ticket_id", null: false
    t.datetime "set_time"
    t.string "set_location"
    t.string "suspension"
    t.text "message"
    t.text "contact_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_ticket_id"], name: "index_ticket_buyer_limiteds_on_post_ticket_id"
  end

  create_table "ticket_inquiries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_ticket_id", null: false
    t.string "email"
    t.string "subject"
    t.text "message"
    t.string "name"
    t.string "contributor_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_ticket_id"], name: "index_ticket_inquiries_on_post_ticket_id"
    t.index ["user_id"], name: "index_ticket_inquiries_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "display_name"
    t.integer "postcode"
    t.integer "prefecture_code"
    t.string "address_city"
    t.string "address_street"
    t.string "address_building"
    t.date "birthday"
    t.integer "contributor_code"
    t.string "contributor_name"
    t.string "contributor_festival"
    t.text "contributor_introduction"
    t.string "customer_id"
    t.string "financial_institution"
    t.string "branch_name"
    t.string "deposit_type"
    t.string "account_number"
    t.string "account_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bids", "posts"
  add_foreign_key "bids", "users"
  add_foreign_key "event_inquiries", "posts"
  add_foreign_key "event_inquiries", "users"
  add_foreign_key "hammers", "bids"
  add_foreign_key "hammers", "posts"
  add_foreign_key "hammers", "users"
  add_foreign_key "inquiries", "users"
  add_foreign_key "post_tickets", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "purchasing_quantities", "post_tickets"
  add_foreign_key "purchasing_quantities", "users"
  add_foreign_key "successful_bidder_limiteds", "posts"
  add_foreign_key "ticket_buyer_limiteds", "post_tickets"
  add_foreign_key "ticket_inquiries", "post_tickets"
  add_foreign_key "ticket_inquiries", "users"
end
