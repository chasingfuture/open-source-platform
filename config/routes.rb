Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root routing
  # use a dedicated controller for this specific route
  root to: 'root#index'

  # Sessions related routes
  get    '/login',                 to: 'sessions#new',     as: :login
  delete '/logout',                to: 'sessions#destroy', as: :logout
  get    '/oauth/callback/github', to: 'sessions#create'

  # Projects-related routes
  resources :projects, param: :slug

end
