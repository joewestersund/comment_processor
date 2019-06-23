Rails.application.routes.draw do

  resources :rulemakings
  post 'rulemakings/switch/:id', to: 'rulemakings#switch', as: 'rulemakings_switch'

  resources :user_permissions
  resources :comment_data_sources
  resources :change_log_entries
  resources :suggested_change_response_types
  post '/suggested_change_response_types/:id/move_up', to: 'suggested_change_response_types#move_up'
  post '/suggested_change_response_types/:id/move_down', to: 'suggested_change_response_types#move_down'

  resources :suggested_change_status_types
  post '/suggested_change_status_types/:id/move_up', to: 'suggested_change_status_types#move_up'
  post '/suggested_change_status_types/:id/move_down', to: 'suggested_change_status_types#move_down'

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

  get 'password/forgot', to: 'users#forgot_password'
  post 'password/send_reset_email', to: 'users#send_password_reset_email'
  get 'password/reset/:token', to: 'users#reset_password'

  get '/profile/edit_password', to: 'users#edit_password'
  get '/profile/edit', to: 'users#edit_profile'
  patch '/profile/update_password', to: 'users#update_password'
  patch '/profile/update', to: 'users#update_profile'

  get 'suggested_changes/renumber', to: 'suggested_changes#renumber'
  put 'suggested_changes/renumber', to: 'suggested_changes#do_renumber', as: 'suggested_changes_do_renumber'
  get 'suggested_changes/merge', to: 'suggested_changes#merge'
  put 'suggested_changes/merge_preview', to: 'suggested_changes#merge_preview'
  post 'suggested_changes/:id/merge/:from_suggested_change_id', to: 'suggested_changes#do_merge', as: 'suggested_changes_do_merge'
  get 'suggested_changes/copy', to: 'suggested_changes#copy', as: 'suggested_change_copy'
  put 'suggested_changes/copy', to: 'suggested_changes#do_copy', as: 'suggested_change_do_copy'
  resources :suggested_changes
  post '/suggested_changes/:id/move_up', to: 'suggested_changes#move_up'
  post '/suggested_changes/:id/move_down', to: 'suggested_changes#move_down'

  get 'comments/import', to: 'comments#import'
  put 'comments/import', to: 'comments#do_import', as: 'comments_do_import'
  get 'comments/cleanup', to: 'comments#cleanup'
  put 'comments/cleanup', to: 'comments#do_cleanup', as: 'comments_do_cleanup'
  delete 'comments/:id/attached_file/:attached_file_id', :to => 'comments#delete_attachment', as: 'comments_delete_attachment'
  get 'comments/:id/attached_file/:attached_file_id', :to => 'comments#show_attachment', as: 'comments_show_attachment'
  resources :comments

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: "sessions#new"
  delete '/signout', to: "sessions#destroy"

  get '/stats/comments', to: "stats#comments"
  get '/stats/suggested_changes', to: "stats#suggested_changes"

  root 'static_pages#about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
