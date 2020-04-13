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

ActiveRecord::Schema.define(version: 2020_04_13_002032) do

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

  create_table "categoria", force: :cascade do |t|
    t.string "nombre"
    t.integer "numero_jugadores"
    t.integer "numero_grupos"
    t.integer "numero_jugadores_grupo"
    t.string "tipo"
    t.bigint "torneo_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["torneo_id"], name: "index_categoria_on_torneo_id"
  end

  create_table "cuadros", force: :cascade do |t|
    t.integer "numero"
    t.string "etapa"
    t.bigint "categorium_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["categorium_id"], name: "index_cuadros_on_categorium_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.integer "numero"
    t.string "nombre"
    t.bigint "categorium_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["categorium_id"], name: "index_grupos_on_categorium_id"
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
    t.bigint "categorium_id"
    t.index ["categorium_id"], name: "index_jugadors_on_categorium_id"
  end

  create_table "llaves", force: :cascade do |t|
    t.integer "numero"
    t.string "etapa"
    t.bigint "categorium_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["categorium_id"], name: "index_llaves_on_categorium_id"
  end

  create_table "torneos", force: :cascade do |t|
    t.string "nombre"
    t.date "fecha_inicio"
    t.date "fecha_fin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categoria", "torneos"
  add_foreign_key "cuadros", "categoria"
  add_foreign_key "grupos", "categoria"
  add_foreign_key "jugadors", "categoria"
  add_foreign_key "llaves", "categoria"
end
