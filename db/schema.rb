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

ActiveRecord::Schema.define(version: 2018_09_20_120042) do

  create_table "abs_modules", force: :cascade do |t|
    t.string "titre"
    t.string "dim"
    t.text "long_description"
    t.text "short_description"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "nom"
    t.string "prenom"
    t.integer "sexe", limit: 1
    t.integer "birthyear", limit: 4
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.integer "statut", limit: 2, default: 0
    t.string "options", default: "00000000"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
