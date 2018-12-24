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