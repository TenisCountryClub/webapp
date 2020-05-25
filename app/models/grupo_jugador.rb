class GrupoJugador < ApplicationRecord
  belongs_to :grupo
  belongs_to :jugador
 
end
