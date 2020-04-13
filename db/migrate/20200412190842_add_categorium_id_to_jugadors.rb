class AddCategoriumIdToJugadors < ActiveRecord::Migration[6.0]
  def change
    add_reference :jugadors, :categorium, null: true, foreign_key: true
  end
end
