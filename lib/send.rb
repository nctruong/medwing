# require 'bunny'
# con = Bunny.new
# con.start
# channel = con.create_channel
# queue = channel.queue('hello')
# channel.default_exchange.publish('hello workd!', routing_key: queue.name)
# con.close

require 'json'
require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel

10.times do
  id = ::Reading.maximum(:id).next
  ch.default_exchange.publish({ id: id,
                                temperature: 30.2,
                                humidity: 50,
                                battery_charge: 33.2,
                                thermostat_id: 1 }.to_json, routing_key: 'request.readings.create')
  # set ID to redis
  Redis.current.set('reading_id', id.to_s)
  # start worker
  worker = ReadingWorker::GetWorker.new
  worker.run

  # query db

  # grab result
  worker.stop
  puts "result: #{Redis.current.get(id.to_s)}"
end

conn.close