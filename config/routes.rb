Rails.application.routes.draw do
  
  resources :torneos do
  	resources :llaves
  	resources :grupos
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
