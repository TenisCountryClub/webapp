class CreateCategoria < ActiveRecord::Migration[6.0]
  def change
    create_table :categoria do |t|
      t.string :nombre
      t.integer :numero_jugadores
      t.integer :numero_grupos
      t.integer :numero_jugadores_grupo
      t.string :tipo
      t.references :torneo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
