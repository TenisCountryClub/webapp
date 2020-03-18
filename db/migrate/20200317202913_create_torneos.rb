class CreateTorneos < ActiveRecord::Migration[6.0]
  def change
    create_table :torneos do |t|
      t.string :nombre
      t.date :fechaInicio
      t.date :fechaFin
      t.string :tipo

      t.timestamps
    end
  end
end
