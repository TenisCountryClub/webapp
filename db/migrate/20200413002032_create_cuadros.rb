class CreateCuadros < ActiveRecord::Migration[6.0]
  def change
    create_table :cuadros do |t|
      t.integer :numero
      t.string :etapa
      t.references :categorium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
