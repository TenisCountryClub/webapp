class Partido < ApplicationRecord
  belongs_to :jugador_uno, :class_name => 'Jugador', optional: true
  belongs_to :jugador_dos, :class_name => 'Jugador', optional: true
  belongs_to :grupo, optional: true
  belongs_to :cuadro, optional: true
  belongs_to :ronda_torneo

  def torneo
  	if self.grupo
  		return self.grupo.categorium.torneo
  	else
  		return self.cuadro.categorium.torneo
  	end
  end

  def setter(jugador_uno, jugador_dos, hora_inicio,ronda,numero_cancha,grupo, cuadro,numero, ronda_torneo)
  	self.jugador_uno= jugador_uno
  	self.jugador_dos= jugador_dos
  	self.hora_inicio= hora_inicio
  	self.ronda= ronda
  	self.numero_cancha= numero_cancha
  	self.grupo= grupo
  	self.cuadro= cuadro
  	self.numero= numero
  	self.ronda_torneo= ronda_torneo

  	self.save
  end
end
