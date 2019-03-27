Rails.application.routes.draw do
  post '/pull-request' => 'github_hooks#pull_request'
end
