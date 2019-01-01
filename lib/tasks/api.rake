desc ''
task post_reading: :environment do
  Reading.destroy_all
  Sidekiq.redis { |con| con.flushdb }
  reading_service = ApiServices::ReadingService.new
  th1 = Thread.new do
    # 10.times do
    loop do
      reading_service.post(
        temperature: 30.2,
        humidity: 50,
        battery_charge: 33.2,
        thermostat_id: 1
      )
    end
  end

  th2 = Thread.new do
    loop do
      reading_service.post(
          temperature: 30.2,
          humidity: 50,
          battery_charge: 33.2,
          thermostat_id: 2
      )
    end
  end

  th1.join
  th2.join
  puts 'done.'
end

require 'json'
require 'bunny'
require 'timeout'
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
    puts RabbitmqServices::Reading.get(data['id'])
    # do |result|
    #   # puts "result: " << (result || 'NULL')
    #   # byebug
    #   p result
    #   # puts "thermostat_id: #{(result.present? ? JSON.parse(result.gsub("=>",":"))['thermostat_id'] : 'NOT FOUND')}"
    # end
    # RabbitmqServices::Reading.get(id)
  end
end

task check: :environment do
  pool = RedisServices::ReadingPool
  Redis.current.get('readings-id').split(',').each do |id|
    puts "id##{id} exist ========================================================#{pool.id_exists?(id)}"
    if pool.id_exists?(id)
      key = pool.options[:value] << id
      puts "#{key}:  #{pool.get_result(id)}"
    end
  end
end