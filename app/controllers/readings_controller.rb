class ReadingsController < ApplicationController

  def show
    thermostat_id = RabbitmqServices::Reading.get(params[:id])['thermostat_id']
    if thermostat_id.present?
      thermostat = Thermostat.find_by(id: thermostat_id)
      render_json({ thermostat: thermostat })
    else
      render_not_found(thermostat_id)
    end
  end

  def create
    if reading_params[:thermostat_id] && thermostat_exists?(reading_params[:thermostat_id])
      id = RabbitmqServices::Reading.post(reading_params.to_h)
      render_json({ id: id })
    else
      thermostat_id(reading_params[:thermostat_id])
    end
  rescue
    render_json({ message: "Can't create reading with params: #{params}" }, HTTP_STATUS[:bad_request])
  end

  private
    def thermostat_exists?(id)
      Thermostat.find_by(id: id).present?
    end

    def render_not_found(id)
      render_json({ message: "Id##{id} not found" }, HTTP_STATUS[:not_found])
    end

    def reading_params
      params.require(:reading).permit(:number, :temperature, :humidity, :battery_charge, :thermostat_id)
    end
end
