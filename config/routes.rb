Rails.application.routes.draw do
  resources :users
  resources :categories
  resources :comments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
