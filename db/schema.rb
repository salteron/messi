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

ActiveRecord::Schema.define(version: 2019_02_28_144032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deliveries", force: :cascade do |t|
    t.bigint "message_id", null: false
    t.string "message_text_md5", null: false
    t.integer "recipient_messenger", null: false
    t.string "recipient_messenger_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_deliveries_on_message_id"
    t.index ["recipient_messenger", "recipient_messenger_user_id", "message_text_md5"], name: "uniq_idx_deliveries_on_recipient_and_text", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "text", null: false
    t.datetime "send_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "deliveries", "messages"
end
