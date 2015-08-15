Rails.application.routes.draw do
  resources :leagues

  resource :session, :only => [:new, :create, :destroy]
  resources :users, except: [:index]

  get "static_pages/login" => "static_pages#login"
  get "static_pages/table" => "static_pages#table"
  root to: 'sessions#new'

  # ------------------------ Aliases ----------------------------

  get "signin" => "sessions#new"
  delete "signout" => "sessions#destroy"
  get "signup" => "users#new"

end
