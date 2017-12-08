Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root routing
  # use a dedicated controller for this specific route
  root to: 'root#index'

  # Registration-related routes
  get '/login', to: 'registration#login', as: :login
  get '/oauth/callback/github', to: 'registration#login_via_github'

  # Projects-related routes
  resources :projects, param: :slug

end
