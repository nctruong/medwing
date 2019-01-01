class ThermostatsController < ApplicationController
  before_action :set_thermostat, only: [:show, :update, :destroy]

  # GET /thermostats
  def index
    @thermostats = Thermostat.all

    render json: @thermostats
  end

  # GET /thermostats/1
  def show
    render json: @thermostat
  end

  # POST /thermostats
  def create
    @thermostat = Thermostat.new(thermostat_params)

    if @thermostat.save
      render json: @thermostat, status: :created, location: @thermostat
    else
      render json: @thermostat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /thermostats/1
  def update
    if @thermostat.update(thermostat_params)
      render json: @thermostat
    else
      render json: @thermostat.errors, status: :unprocessable_entity
    end
  end

  # DELETE /thermostats/1
  def destroy
    @thermostat.destroy
  end

  private
    # Use callbacks to share util_queries setup or constraints between actions.
    def set_thermostat
      @thermostat = Thermostat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def thermostat_params
      params.require(:thermostat).permit(:household_token, :location)
    end
end
