class IncidentsController < ApplicationController
  def index
    @incidents = Persistence::INCIDENTS_REPOSITORY.find_last_n_with_messages(10).to_json

    render json: @incidents
  end
end
