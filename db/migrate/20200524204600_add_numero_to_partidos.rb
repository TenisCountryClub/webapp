class AddNumeroToPartidos < ActiveRecord::Migration[6.0]
  def change
    add_column :partidos, :numero, :integer
  end
end
