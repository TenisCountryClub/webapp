class AddNumeroSiembraToCuadroJugadors < ActiveRecord::Migration[6.0]
  def change
    add_column :cuadro_jugadors, :numero_siembra, :integer
  end
end
