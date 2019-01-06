require 'json'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO


task test_reading: :environment do
  reading_api = ApiServices::ReadingService.new
  stat_api = ApiServices::StatService.new
  10.times { Thermostat.create(location: "HCM")}
  thermostats = Thermostat.all
  10.times do |t|
    thermostat_id = thermostats.sample.id
    data = reading_api.post({
                                  temperature: 30.2,
                                  humidity: 50,
                                  battery_charge: 33.2,
                                  thermostat_id: thermostat_id })
    puts "* #{t + 1}. id posted: #{data['id']} ----------------------------------------------------------------"
    p "------ get: #{reading_api.get(data['id'])}"
    p "------ average: #{stat_api.get(thermostat_id)}"
  end
end