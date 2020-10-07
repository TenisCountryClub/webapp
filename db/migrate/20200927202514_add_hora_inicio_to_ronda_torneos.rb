class AddHoraInicioToRondaTorneos < ActiveRecord::Migration[6.0]
  def change
    add_column :ronda_torneos, :hora_inicio, :datetime
  end
end
