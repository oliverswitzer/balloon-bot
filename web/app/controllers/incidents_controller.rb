class IncidentsController < ApplicationController
  if %w[staging production].include? Rails.env
    http_basic_authenticate_with name: ENV['HTTP_AUTH_USER'], password: ENV['HTTP_AUTH_PASSWORD']
  end

  def index
    lower_bound = epoch_to_utc(safe_params[:created_after]) if safe_params[:created_after].present?
    upper_bound = epoch_to_utc(safe_params[:created_before]) if safe_params[:created_before].present?

    # noinspection RubyScope
    @incidents = Web::FETCH_INCIDENTS.execute(
      happened_after: lower_bound,
      happened_before: upper_bound
    )

    respond_to do |format|
      format.json { render json: @incidents }
    end
  end

  def all_time_duration
    respond_to do |format|
      format.json { render json: { all_time_duration: Web::CALCULATE_TOTAL_INCIDENT_DURATION.execute } }
    end
  end

  def duration_over_time
    respond_to do |format|
      format.json do
        render json: {
          duration_over_time: {
            months: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
            total_duration_per_month: [5e5, 6e5, 10e6, 1e5, 1e7, 11e5, 1e5]
          }
        }
      end
    end
  end

  private def epoch_to_utc(date_param)
    Time.strptime(date_param, '%Q').utc
  end

  private def safe_params
    params.permit(:created_after, :created_before, :format)
  end
end
