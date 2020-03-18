class CreateLlaves < ActiveRecord::Migration[6.0]
  def change
    create_table :llaves do |t|
      t.references :torneo, null: false, foreign_key: true
      t.string :etapa
      t.integer :numero

      t.timestamps
    end
  end
end
