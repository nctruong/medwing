desc ''
task post_reading: :environment do
  10.times do
    response = ApiServices::ReadingService.new.post(
      temperature: 30.2,
      humidity: 50,
      battery_charge: 33.2,
      thermostat_id: 1
    )
    # puts response
  end
  puts 'done.'
end