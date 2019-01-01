class ReadingsController < ApplicationController
  before_action :set_reading, only: [:show]

  def show
    render json: @reading.thermostat
  end

  def create
    # job_info = ReadingJob.perform_later(reading_params.to_h)
    id = RabbitmqServices::Reading.post(reading_params.to_h)
    # byebug
    render json: { id: id }, status: 200
  end

  private
    def set_reading
      @reading = RabbitmqServices::Reading.get(params[:id])
    end

    def reading_params
      params.require(:readings).permit(:number, :temperature, :humidity, :battery_charge, :thermostat_id)
    end
end
