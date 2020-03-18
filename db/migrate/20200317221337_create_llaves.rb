class CreateLlaves < ActiveRecord::Migration[6.0]
  def change
    create_table :llaves do |t|
      t.string :etapa
      t.integer :numero

      t.timestamps
    end
  end
end
