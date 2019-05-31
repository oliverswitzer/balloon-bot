class IncidentsController < ApplicationController
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
