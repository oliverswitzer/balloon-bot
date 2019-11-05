Rails.application.routes.draw do
  post '/pull-request' => 'github_hooks#pull_request'

  root 'application#index'

  resources :incidents, only: [:index]
end
