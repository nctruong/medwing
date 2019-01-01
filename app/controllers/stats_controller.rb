class StatsController < ApplicationController
  def index
    thermostat_id = params[:thermostat_id]
    ReadingQueries::Average.get('temperature', 'humidity', 'battery_charge')
    render_json(thermostat.to_json)
  end
end