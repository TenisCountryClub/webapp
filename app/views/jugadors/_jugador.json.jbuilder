json.extract! jugador, :id, :numero, :nombre, :ranking, :edad, :club_asociacion, :fecha_inscripcion, :status, :created_at, :updated_at
json.url jugador_url(jugador, format: :json)
