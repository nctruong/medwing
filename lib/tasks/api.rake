require 'json'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO


task test_reading: :environment do
  api_service = ApiServices::ReadingService.new
  10.times { Thermostat.create(location: "HCM")}
  thermostats = Thermostat.all
  10.times do |t|
    data = api_service.post({
                                  temperature: 30.2,
                                  humidity: 50,
                                  battery_charge: 33.2,
                                  thermostat_id: thermostats.sample.id })
    puts "* #{t + 1}, id: #{data['id']}"
    p api_service.get(data['id'])
  end
end