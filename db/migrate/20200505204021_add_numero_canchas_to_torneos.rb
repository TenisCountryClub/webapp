class AddNumeroCanchasToTorneos < ActiveRecord::Migration[6.0]
  def change
    add_column :torneos, :numero_canchas, :integer
  end
end
