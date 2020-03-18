json.extract! torneo, :id, :nombre, :fechaInicio, :fechaFin, :tipo, :created_at, :updated_at
json.url torneo_url(torneo, format: :json)
