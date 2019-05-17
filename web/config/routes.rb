Rails.application.routes.draw do
  post '/pull-request' => 'github_hooks#pull_request'

  resources :incidents, only: [:index]
end
