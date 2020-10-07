Rails.application.routes.draw do
 
  resources :partidos
  resources :grupo_jugadors
  resources :cuadro_jugadors
  root 'index#index'
  resources :torneos do
    resources :categoria do
          resources :cuadro_jugadors
          resources :grupo_jugadors
          resources :grupos
          resources :cuadros
    end
  end
  
  Rails.application.routes.default_url_options[:host] = "localhost:3000"


  get '/torneos/:torneo_id/categoria/:id/sortear', to: 'categoria#sortear'
  get '/torneos/:torneo_id/categoria/:id/generar.json', to: 'categoria#generar'
  resources :jugadors
    post '/asociar_jugador.json', to: 'jugadors#asociar_jugador'
  get '/torneos/:id/horario', to: 'torneos#horario'


  	
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
