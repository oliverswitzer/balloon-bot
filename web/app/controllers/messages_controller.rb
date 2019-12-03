class MessagesController < ApplicationController
  def index
    @messages = Web::FETCH_MESSAGES_FOR_INCIDENT.execute(incident_id: params[:incident_id])

    respond_to do |format|
      format.json { render json: @messages }
    end
  end
end