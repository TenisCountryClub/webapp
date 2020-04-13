class CreateGrupos < ActiveRecord::Migration[6.0]
  def change
    create_table :grupos do |t|
      t.integer :numero
      t.string :nombre
      t.references :categorium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
