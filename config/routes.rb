Rails.application.routes.draw do
  
  resources :torneos
  	resources :llaves
  	resources :grupos

  	get '/obtener_jugadores', to: 'torneos#obtener_jugadores'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
