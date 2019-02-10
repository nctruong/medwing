class StatsController < ApplicationController
  def average
    thermostat_id = params[:thermostat_id]
    unless Thermostat.find_by(id: thermostat_id).nil?
      result = RedisServices::ReadingPool.average&.gsub('=>',':')
      render_json(result)
    else
      render_json({ message: 'Thermostat_id not found' }, HTTP_STATUS[:not_found])
    end
  end
end