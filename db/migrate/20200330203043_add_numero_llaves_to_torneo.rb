class AddNumeroLlavesToTorneo < ActiveRecord::Migration[6.0]
  def change
    add_column :torneos, :numero_llaves, :integer
  end
end
