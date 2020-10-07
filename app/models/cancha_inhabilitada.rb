class CanchaInhabilitada < ApplicationRecord
  belongs_to :ronda_torneo

  def self.crear(numero_cancha,hora,ronda_torneo)
  	cancha= CanchaInhabilitada.new
  	cancha.numero_cancha=numero_cancha
  	cancha.hora= hora
  	cancha.ronda_torneo=ronda_torneo
  	cancha.save
  end

  def self.puta
  	puts "puta"
  end
end
