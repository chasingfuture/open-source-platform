Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root routing
  # use a dedicated controller for this specific route
  root to: 'root#index'

  # Sessions related routes
  get    '/login',                 to: 'sessions#new',     as: :login
  delete '/logout',                to: 'sessions#destroy', as: :logout
  get    '/oauth/callback/github', to: 'sessions#create'

  # Users & Projects related routes
  resources :users, param: :login, only: [:show, :update] do

    nested do
      # projects are scoped by platform
      scope '/:platform' do
        # Projects-related routes
        resources :projects, param: :slug, only: [:show], path: '', constraints: { slug: /[^\/]+/ }
      end
    end

  end

end
