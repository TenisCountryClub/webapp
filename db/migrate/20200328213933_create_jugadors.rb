class CreateJugadors < ActiveRecord::Migration[6.0]
  def change
    create_table :jugadors do |t|
      t.integer :numero
      t.string :nombre
      t.integer :ranking
      t.integer :edad
      t.string :club_asociacion
      t.datetime :fecha_inscripcion
      t.string :status

      t.timestamps
    end
  end
end
