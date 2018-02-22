Rails.application.routes.draw do

  resources :change_log_entries
  resources :category_response_types
  post '/category_response_types/:id/move_up', to: 'category_response_types#move_up'
  post '/category_response_types/:id/move_down', to: 'category_response_types#move_down'

  resources :category_status_types
  post '/category_status_types/:id/move_up', to: 'category_status_types#move_up'
  post '/category_status_types/:id/move_down', to: 'category_status_types#move_down'

  resources :comment_status_types
  post '/comment_status_types/:id/move_up', to: 'comment_status_types#move_up'
  post '/comment_status_types/:id/move_down', to: 'comment_status_types#move_down'

  get 'sessions/new'

  get 'static_pages/about'

  get 'static_pages/welcome'

  get '/about', to: 'static_pages#about' # creates named path 'about'
  get '/welcome', to: 'static_pages#welcome' # creates named path 'welcome'
  get '/addusers', to: 'users#new' # creates named path 'addusers'

  resources :users
  post '/users/:id/reset_password', to: 'users#reset_password'

  get '/profile/edit_password', to: 'users#edit_password'
  get '/profile/edit', to: 'users#edit_profile'
  patch '/profile/update_password', to: 'users#update_password'

  get 'categories/renumber', to: 'categories#renumber'
  put 'categories/renumber', to: 'categories#do_renumber', as: 'categories_do_renumber'
  get 'categories/merge', to: 'categories#merge'
  put 'categories/preview_merge', to: 'categories#preview_merge'
  post 'categories/:id/merge/:from_category_id', to: 'categories#do_merge', as: 'categories_do_merge'
  get 'categories/copy', to: 'categories#copy', as: 'category_copy'
  put 'categories/copy', to: 'categories#do_copy', as: 'category_do_copy'
  resources :categories
  post '/categories/:id/move_up', to: 'categories#move_up'
  post '/categories/:id/move_down', to: 'categories#move_down'

  get 'comments/import', to: 'comments#import'
  put 'comments/import', to: 'comments#do_import', as: 'comments_do_import'
  get 'comments/cleanup', to: 'comments#cleanup'
  put 'comments/cleanup', to: 'comments#do_cleanup', as: 'comments_do_cleanup'
  resources :comments

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  delete '/signout', to: "sessions#destroy"

  get '/stats/comments', to: "stats#comments"
  get '/stats/categories', to: "stats#categories"

  root 'static_pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
