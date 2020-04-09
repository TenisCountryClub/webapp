Rails.application.routes.draw do

	Rails.application.routes.default_url_options[:host] = "localhost:3000"
  
  resources :jugadors
  resources :torneos
  	resources :llaves
  	resources :grupos

  	get  '/obtener_hoja_calculo', to: 'torneos#obtener_hoja_calculo'
  	post '/obtener_jugadores', to: 'torneos#obtener_jugadores'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
