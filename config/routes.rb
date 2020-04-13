Rails.application.routes.draw do
 
  
  resources :torneos do
    resources :categoria do
          resources :grupos
          resources :cuadros
    end
  end
  
  Rails.application.routes.default_url_options[:host] = "https://tenis-country-club-cbba.herokuapp.com/"


  
  resources :jugadors
    post '/asociar_jugador/:id', to: 'jugadors#asociar_jugador'
  	get  '/obtener_hoja_calculo', to: 'torneos#obtener_hoja_calculo'
  	post '/obtener_jugadores', to: 'torneos#obtener_jugadores'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
