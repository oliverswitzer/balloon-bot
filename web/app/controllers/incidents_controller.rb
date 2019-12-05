class IncidentsController < ApplicationController
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

  def stats_over_time
    respond_to do |format|
      format.json do
        render json: {
          stats_over_time: Web::CALCULATE_INCIDENT_STATS_OVER_TIME.execute
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
