class RenameNumeroCanchasToNumeroCancha < ActiveRecord::Migration[6.0]
  def change
  	rename_column :partidos, :numero_canchas, :numero_cancha
  end
end
