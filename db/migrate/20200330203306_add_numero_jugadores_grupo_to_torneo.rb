class AddNumeroJugadoresGrupoToTorneo < ActiveRecord::Migration[6.0]
  def change
    add_column :torneos, :numero_jugadores_grupo, :integer
  end
end
