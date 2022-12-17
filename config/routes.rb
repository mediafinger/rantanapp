Rails.application.routes.draw do
  resources :members
  resources :teams
  resources :users

  root to: "teams#index"

  # catch all unknown routes to NOT throw a FATAL ActionController::RoutingError
  match "*path", to: "application#error_404", via: :all,
    constraints: ->(request) { !request.path_parameters[:path].start_with?("rails/") }
end
