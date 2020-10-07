class RondaTorneo < ApplicationRecord
  has_many :partidos
  has_many :cancha_inhabilitadas

  def setter(numero,numero_canchas,hora_inicio)
  	self.numero= numero
  	self.numero_canchas= numero_canchas
  	self.hora_inicio= hora_inicio
  	self.save
  end
end