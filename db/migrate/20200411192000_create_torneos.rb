class CreateTorneos < ActiveRecord::Migration[6.0]
  def change
    create_table :torneos do |t|
      t.string :nombre
      t.date :fecha_inicio
      t.date :fecha_fin

      t.timestamps
    end
  end
end
