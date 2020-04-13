class Jugador < ApplicationRecord
	belongs_to :categorium
	validates :numero, :nombre, :ranking, :edad, :club_asociacion, :fecha_inscripcion, :status, presence: true
end
