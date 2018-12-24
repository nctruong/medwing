class ReadingsController < ApplicationController
  before_action :set_reading, only: [:show, :update, :destroy]

  def show
    render json: @reading
  end

  def create
    # job_info = ReadingJob.perform_later(reading_params.to_h)
    job_info = ReadingWorker.perform_later(reading_params.to_h)
    # byebug
    render json: { job_info: job_info.to_s }, status: 200
  end

  private
    def set_reading
      @reading = Reading.find(params[:id])
    end

    def reading_params
      params.require(:reading).permit(:number, :temperature, :humidity, :battery_charge, :thermostat_id)
    end
end
