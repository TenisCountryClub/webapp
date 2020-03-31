class Grupo < ApplicationRecord
  belongs_to :torneo
  attr_accessor :numero, :numeroJugadores

  def set_numero(valor)
  	 write_attribute(:numero, valor)
  	 puts "hola2"
  	end

  	def set_numeroJugadores(valor)
  		write_attribute(:numeroJugadores, valor)
  	end

  	def numeroJugadores
  		self[:numeroJugadores]
  	end

  	def numero
  		self[:numero]
  	end
end
