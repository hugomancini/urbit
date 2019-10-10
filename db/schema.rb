# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_10_173301) do

  create_table "check_outs", force: :cascade do |t|
    t.string "cart_token"
    t.string "fees"
    t.string "valid_address"
    t.string "delivery_time"
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address_1"
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "postcode"
    t.string "phone_number"
    t.string "u_cart_id"
    t.string "u_checkout_id"
    t.string "email"
    t.string "address_2"
    t.boolean "free_urbit"
  end

end
