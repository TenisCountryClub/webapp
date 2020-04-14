class Jugador < ApplicationRecord
	belongs_to :categorium, optional: true
	validates :numero, :nombre, presence: true
end
