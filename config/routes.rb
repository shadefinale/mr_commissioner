Rails.application.routes.draw do
  resources :leagues, only: [:show]

  get "static_pages/login" => "static_pages#login"
  get "static_pages/table" => "static_pages#table"
  root to: 'static_pages#login'
end
