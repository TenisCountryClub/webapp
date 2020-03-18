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

ActiveRecord::Schema.define(version: 2020_03_18_003129) do

  create_table "grupos", force: :cascade do |t|
    t.integer "torneo_id", null: false
    t.integer "numero"
    t.integer "numeroJugadores"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["torneo_id"], name: "index_grupos_on_torneo_id"
  end

  create_table "llaves", force: :cascade do |t|
    t.integer "torneo_id", null: false
    t.string "etapa"
    t.integer "numero"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["torneo_id"], name: "index_llaves_on_torneo_id"
  end

  create_table "torneos", force: :cascade do |t|
    t.string "nombre"
    t.date "fechaInicio"
    t.date "fechaFin"
    t.string "tipo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "grupos", "torneos"
  add_foreign_key "llaves", "torneos"
end
