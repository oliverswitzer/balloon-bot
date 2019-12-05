Rails.application.routes.draw do
  post '/pull-request' => 'github_hooks#pull_request'

  root 'application#index'

  resources :incidents, only: [:index] do
    resources :messages, only: [:index]
    collection do
      get 'all_time_duration'
      get 'stats_over_time'
    end
  end
end
