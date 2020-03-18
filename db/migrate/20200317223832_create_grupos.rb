class CreateGrupos < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos do |t|
      t.integer :numero
      t.integer :numeroJugadores

      t.timestamps
    end
  end
end
