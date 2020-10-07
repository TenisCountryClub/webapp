class CreateCanchaInhabilitadas < ActiveRecord::Migration[6.0]
  def change
    create_table :cancha_inhabilitadas do |t|
      t.integer :numero_cancha
      t.datetime :hora
      t.references :ronda_torneo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
