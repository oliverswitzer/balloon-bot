class ApplicationController < ActionController::Base
  if %w[staging production].include? Rails.env
    http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASSWORD']
  end
end
