Rails.application.routes.draw do

  resources :category_status_types
  resources :comment_status_types
  get 'sessions/new'

  get 'static_pages/about'

  get 'static_pages/welcome'

  get '/about', to: 'static_pages#about' # creates named path 'about'
  get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'
  get '/addusers', to: 'users#new' # creates named path 'addusers'

  resources :users
  get '/profile/edit_password', to: 'users#edit_password'
  get '/profile/edit', to: 'users#edit_profile'
  patch '/profile/update_password', to: 'users#update_password'

  resources :categories
  post '/categories/:id/move_up', to: 'categories#move_up'
  post '/categories/:id/move_down', to: 'categories#move_down'

  get 'comments/import', to: 'comments#import'
  put 'comments/import', to: 'comments#do_import', as: 'comments_do_import'
  resources :comments

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  delete '/signout', to: "sessions#destroy"

  root 'static_pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
