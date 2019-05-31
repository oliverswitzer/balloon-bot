class IncidentsController < ApplicationController
  if %w(staging production).include? Rails.env
    http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASSWORD']
  end

  def index
    @incidents = Persistence::INCIDENTS_REPOSITORY.find_last_n_with_messages(
      safe_params[:last].to_i
    )

    respond_to do |format|
      format.json { render json: @incidents }
      format.html { render :index }
    end
  end

  private def safe_params
    params.permit(:last)
  end
end
