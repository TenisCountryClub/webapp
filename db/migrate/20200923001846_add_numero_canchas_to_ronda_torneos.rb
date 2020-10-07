class AddNumeroCanchasToRondaTorneos < ActiveRecord::Migration[6.0]
  def change
    add_column :ronda_torneos, :numero_canchas, :integer
  end
end
