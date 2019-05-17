class IncidentsController < ApplicationController
  def index
    @incidents = Persistence::INCIDENTS_REPOSITORY.find_last_n_with_messages(
      safe_params[:last].to_i
    ).to_json

    render json: @incidents
  end

  private def safe_params
    params.permit(:last)
  end
end
