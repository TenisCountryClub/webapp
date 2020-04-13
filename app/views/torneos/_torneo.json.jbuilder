json.extract! torneo, :id, :nombre, :fecha_inicio, :fecha_fin, :created_at, :updated_at
json.url torneo_url(torneo, format: :json)
