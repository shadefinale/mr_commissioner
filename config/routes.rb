Rails.application.routes.draw do
  resources :leagues, only: [:show]
end
