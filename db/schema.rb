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

ActiveRecord::Schema.define(version: 2020_03_30_203306) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
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

  create_table "grupos", force: :cascade do |t|
    t.integer "torneo_id", null: false
    t.integer "numero"
    t.integer "numeroJugadores"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["torneo_id"], name: "index_grupos_on_torneo_id"
  end

  create_table "jugadors", force: :cascade do |t|
    t.integer "numero"
    t.string "nombre"
    t.integer "ranking"
    t.integer "edad"
    t.string "club_asociacion"
    t.datetime "fecha_inscripcion"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "numero_llaves"
    t.integer "numero_grupos"
    t.integer "numero_jugadores_grupo"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "grupos", "torneos"
  add_foreign_key "llaves", "torneos"
end
