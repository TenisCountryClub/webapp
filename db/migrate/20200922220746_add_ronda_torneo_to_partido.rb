class AddRondaTorneoToPartido < ActiveRecord::Migration[6.0]
  def change
    add_reference :partidos, :ronda_torneo, null: false, foreign_key: true
  end
end
