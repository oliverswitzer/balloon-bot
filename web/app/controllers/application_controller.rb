class ApplicationController < ActionController::Base

  def index
    render :index, layout: 'base'
  end
end
