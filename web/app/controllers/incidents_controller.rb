class IncidentsController < ApplicationController
  if %w[staging production].include? Rails.env
    http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASSWORD']
  end

  def index
    lower_bound = Time.at(safe_params[:created_after].to_i) if safe_params[:created_after]
    upper_bound = Time.at(safe_params[:created_before].to_i) if safe_params[:created_before]

    # noinspection RubyScope
    @incidents = Persistence::INCIDENTS_REPOSITORY.find_by_created_at_with_messages(
      lower_bound: lower_bound,
      upper_bound: upper_bound
    )

    respond_to do |format|
      format.json { render json: @incidents }
      format.html { render :index }
    end
  end

  private def safe_params
    params.permit(:created_after, :created_before, :format)
  end
end
