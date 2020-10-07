class CreateRondaTorneos < ActiveRecord::Migration[6.0]
  def change
    create_table :ronda_torneos do |t|
      t.integer :numero

      t.timestamps
    end
  end
end
