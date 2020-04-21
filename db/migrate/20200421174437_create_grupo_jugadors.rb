class CreateGrupoJugadors < ActiveRecord::Migration[6.0]
  def change
    create_table :grupo_jugadors do |t|
      t.references :grupo, null: false, foreign_key: true
      t.references :jugador, null: false, foreign_key: true
      t.integer :numero

      t.timestamps
    end
  end
end
