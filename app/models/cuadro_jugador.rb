class CuadroJugador < ApplicationRecord
  belongs_to :cuadro
  belongs_to :jugador
end
