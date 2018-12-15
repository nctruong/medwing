class ReadingJob < ApplicationJob
  queue_as :default

  def perform(options)
    puts "creating reading...with options: #{options}"
    r = Reading.create(options)
    puts "id: #{r.id}, seq: #{r.number}"
  rescue => e
    puts e
  end
end

# ReadingJob.new( temperature: 30.2, humidity: 50, battery_charge: 33.2, thermostat_id: 1 ).perform_now