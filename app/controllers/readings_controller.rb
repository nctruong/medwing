class ReadingsController < ApplicationController

  def show
    thermostat_id = RabbitmqServices::Reading.get(params[:id])['thermostat_id']
    if thermostat_id.present?
      thermostat = Thermostat.find_by(id: thermostat_id)
      render_json({ thermostat: thermostat })
    else
      render_json({ message: 'Thermostat_id not found' }, HTTP_STATUS[:not_found])
    end
  end

  def create
    id = RabbitmqServices::Reading.post(reading_params.to_h)
    render_json({ id: id })
  rescue
    render_json({ message: "Can't create reading with params: #{params}" }, HTTP_STATUS[:bad_request])
  end

  private

    def reading_params
      params.require(:reading).permit(:number, :temperature, :humidity, :battery_charge, :thermostat_id)
    end
end
