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
  20.times do
    id = RabbitmqServices::Reading.post({
                                  temperature: 30.2,
                                  humidity: 50,
                                  battery_charge: 33.2,
                                  thermostat_id: 1 })
    res = RabbitmqServices::Reading.get(id)
    puts "result for id##{id}: #{res}"
    # pool.remove(id)
    id += 1
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