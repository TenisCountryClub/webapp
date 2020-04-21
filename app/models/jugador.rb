class Jugador < ApplicationRecord
	has_many :cuadro_jugadors
	has_many :grupo_jugadors
	belongs_to :categorium, optional: true
	validates :numero, :nombre, presence: {message: "no puede estar vacío"}
end
