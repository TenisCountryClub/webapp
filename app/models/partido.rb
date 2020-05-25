class Partido < ApplicationRecord
  belongs_to :jugador_uno, :class_name => 'Jugador'
  belongs_to :jugador_dos, :class_name => 'Jugador'
  belongs_to :grupo, optional: true
  belongs_to :cuadro, optional: true
end
