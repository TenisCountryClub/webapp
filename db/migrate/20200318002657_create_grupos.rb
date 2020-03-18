class CreateGrupos < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos do |t|
      t.references :torneo, null: false, foreign_key: true
      t.integer :numero
      t.integer :numeroJugadores

      t.timestamps
    end
  end
end
