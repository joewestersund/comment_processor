Rails.application.routes.draw do

  get 'sessions/new'

  get 'static_pages/about'

  get 'static_pages/welcome'

  get '/about', to: 'static_pages#about' # creates named path 'about'
  get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'
  get '/signup', to: 'users#new' # creates named path 'signup'

  resources :users
  get '/profile/edit_password', to: 'users#edit_password'
  get '/profile/edit', to: 'users#edit'
  patch '/profile/update_password', to: 'users#update_password'

  resources :categories
  resources :comments

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  delete '/signout', to: "sessions#destroy"

  root 'static_pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
