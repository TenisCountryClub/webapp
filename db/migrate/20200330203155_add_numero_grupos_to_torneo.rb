class AddNumeroGruposToTorneo < ActiveRecord::Migration[6.0]
  def change
    add_column :torneos, :numero_grupos, :integer
  end
end
