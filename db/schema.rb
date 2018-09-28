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

ActiveRecord::Schema.define(version: 2018_09_27_174104) do

  create_table "abs_etapes", force: :cascade do |t|
    t.integer "numero", limit: 3
    t.integer "abs_module_id"
    t.integer "type"
    t.string "titre"
    t.string "objectif"
    t.text "travail"
    t.text "methode"
    t.integer "duree", limit: 3
    t.integer "duree_max", limit: 4
    t.text "liens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abs_module_id"], name: "index_abs_etapes_on_abs_module_id"
  end

  create_table "abs_modules", force: :cascade do |t|
    t.string "name"
    t.string "dim"
    t.integer "module_id", limit: 2
    t.integer "tarif", limit: 4
    t.text "long_description"
    t.text "short_description"
    t.integer "nombre_jours", limit: 3
    t.string "hduree"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "action_watchers", force: :cascade do |t|
    t.string "model", limit: 50
    t.integer "model_id"
    t.string "action_watcher_path"
    t.datetime "triggered_at"
    t.text "data"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_action_watchers_on_user_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "ic_etapes", force: :cascade do |t|
    t.integer "status", limit: 2, default: 0
    t.string "options", limit: 16
    t.text "travail_propre"
    t.datetime "started_at"
    t.datetime "expected_end_at"
    t.datetime "ended_at"
    t.datetime "expected_comments_at"
    t.integer "ic_module_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ic_module_id"], name: "index_ic_etapes_on_ic_module_id"
  end

  create_table "ic_modules", force: :cascade do |t|
    t.string "project_name"
    t.integer "state", limit: 2, default: 0
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "next_paiement"
    t.integer "abs_module_id"
    t.integer "current_etape_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abs_module_id"], name: "index_ic_modules_on_abs_module_id"
    t.index ["current_etape_id"], name: "index_ic_modules_on_current_etape_id"
    t.index ["user_id"], name: "index_ic_modules_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "digest"
    t.string "action"
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digest"], name: "index_tickets_on_digest", unique: true
    t.index ["user_id"], name: "index_tickets_on_user_id"
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
