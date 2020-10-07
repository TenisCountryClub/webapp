class CreatePartidos < ActiveRecord::Migration[6.0]
  def change
    create_table :partidos do |t|
      t.references :jugador_uno, null: true
      t.references :jugador_dos, null: true
      t.datetime :hora_inicio
      t.datetime :hora_fin
      t.integer :ronda
      t.integer :numero_canchas
      t.references :grupo, null: true, foreign_key: true
      t.references :cuadro, null: true, foreign_key: true

      t.timestamps
    end
  end
end
