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
100.times do
  ch.default_exchange.publish({ temperature: 30.2,
                                humidity: 50,
                                battery_charge: 33.2,
                                thermostat_id: 1 }.to_json, routing_key: 'reading.create')
end

conn.close