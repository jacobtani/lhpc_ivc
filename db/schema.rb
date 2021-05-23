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

ActiveRecord::Schema.define(version: 2021_05_16_043727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoice_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.json "metadata", default: {}
    t.integer "sort_key", null: false
    t.bigint "invoice_id"
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["invoice_id", "most_recent"], name: "index_invoice_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["invoice_id", "sort_key"], name: "index_invoice_transitions_parent_sort", unique: true
    t.index ["invoice_id"], name: "index_invoice_transitions_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_number"
    t.date "invoice_date"
    t.date "due_date"
    t.date "payment_date"
    t.decimal "member_donation", default: "0.0"
    t.decimal "cleaning_donation", default: "0.0"
    t.decimal "payment_received", default: "0.0"
    t.bigint "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_invoices_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "parent_id"
    t.string "family_id", null: false
    t.string "first_name"
    t.string "surname"
    t.date "dob"
    t.date "date_joined"
    t.date "date_left"
    t.string "email"
    t.string "mobile"
    t.string "address"
    t.date "first_aid_expiry"
    t.string "duty_day"
    t.boolean "staff"
    t.boolean "life_member"
    t.boolean "has_caregiver", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "qualifications", force: :cascade do |t|
    t.string "name"
    t.decimal "discount_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "invoice_transitions", "invoices"
end
