class Jugador < ApplicationRecord
	has_many :cuadro_jugadors, dependent: :destroy
	has_many :grupo_jugadors, dependent: :destroy
	belongs_to :categorium, optional: true
	validates :numero, :nombre, presence: {message: "no puede estar vacío"}
	has_many :partidos_jugador_uno, :class_name => "Partido", :foreign_key => "jugador_uno_id"
  	has_many :partidos_jugador_dos, :class_name => "Partido", :foreign_key => "jugador_dos_id"
end
