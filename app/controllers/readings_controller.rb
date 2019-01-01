class ReadingsController < ApplicationController

  def show
    thermostat_id = RabbitmqServices::Reading.get(params[:id])['thermostat_id']
    thermostat = Thermostat.find_by(id: thermostat_id) if thermostat_id.present?
    render_json({ thermostat: thermostat })
  end

  def create
    id = RabbitmqServices::Reading.post(reading_params.to_h)
    render_json({ id: id })
  end

  private

    def reading_params
      params.require(:readings).permit(:number, :temperature, :humidity, :battery_charge, :thermostat_id)
    end
end
