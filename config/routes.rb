Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root routing
  # use a dedicated controller for this specific route
  root to: 'root#index'

end
