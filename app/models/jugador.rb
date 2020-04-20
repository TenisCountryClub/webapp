class Jugador < ApplicationRecord
	belongs_to :categorium, optional: true
	validates :numero, :nombre, presence: {message: "no puede estar vacío"}
end
